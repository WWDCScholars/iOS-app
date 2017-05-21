//
//  ContainerViewTransitionHelper.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 21/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class ContainerViewTransitionHelper {
    
    // MARK: - Private Properties
    
    private let animationDuration: TimeInterval = 0.2
    
    // MARK: - Internal Properties
    
    internal var activeView: UIView?
    internal var inactiveView: UIView?
    
    // MARK: - Lifecycle
    
    internal init(activeView: UIView?, inactiveView: UIView?) {
        self.activeView = activeView
        self.inactiveView = inactiveView
    }
    
    // MARK: - Internal Functions
    
    internal func switchViews() {
        let activeView = self.activeView
        let inactiveView = self.inactiveView
        
        self.activeView = inactiveView
        self.inactiveView = activeView
        
        self.animateActiveView()
        self.animateInactiveView()
    }
    
    // MARK: - Private Functions
    
    private func animateActiveView() {
        self.activeView?.isHidden = false
        UIView.animate(withDuration: self.animationDuration, animations: {
            self.activeView?.alpha = 1.0
        })
    }
    
    private func animateInactiveView() {
        UIView.animate(withDuration: self.animationDuration, animations: {
            self.inactiveView?.alpha = 0.0
        }, completion: { _ in
            self.inactiveView?.isHidden = true
        })
    }
}
