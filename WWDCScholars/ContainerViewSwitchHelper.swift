//
//  ContainerViewSwitchHelper.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 21/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class ContainerViewSwitchHelper {
    
    // MARK: - Private Properties
    
    private let animationDuration: TimeInterval = 0.2
    
    // MARK: - Internal Properties
    
    internal var activeContainerViewElements: ContainerViewElements?
    internal var inactiveContainerViewElements: ContainerViewElements?
    
    // MARK: - Lifecycle
    
    internal init(activeContainerViewElements: ContainerViewElements?, inactiveContainerViewElements: ContainerViewElements?) {
        self.activeContainerViewElements = activeContainerViewElements
        self.inactiveContainerViewElements = inactiveContainerViewElements
    }
    
    // MARK: - Internal Functions
    
    internal func switchViews() {
        let activeContainerViewElements = self.activeContainerViewElements
        let inactiveContainerViewElements = self.inactiveContainerViewElements
        
        self.activeContainerViewElements = inactiveContainerViewElements
        self.inactiveContainerViewElements = activeContainerViewElements
        
        self.activeContainerViewElements?.viewController?.switchedToViewController?()
        self.inactiveContainerViewElements?.viewController?.switchedFromViewController?()
        
        self.animateActiveView()
        self.animateInactiveView()
    }
    
    // MARK: - Private Functions
    
    private func animateActiveView() {
        self.activeContainerViewElements?.view?.isHidden = false
        UIView.animate(withDuration: self.animationDuration, animations: {
            self.activeContainerViewElements?.view?.alpha = 1.0
        })
    }
    
    private func animateInactiveView() {
        UIView.animate(withDuration: self.animationDuration, animations: {
            self.inactiveContainerViewElements?.view?.alpha = 0.0
        }, completion: { _ in
            self.inactiveContainerViewElements?.view?.isHidden = true
        })
    }
}
