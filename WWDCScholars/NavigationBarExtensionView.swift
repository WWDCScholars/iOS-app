//
//  NavigationBarExtensionView.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal final class NavigationBarExtensionView: UIView {
    
    // MARK: - Private Properties
    
    private let bottomBorderView = UIView()
    
    // MARK: - Lifecycle
    
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.styleUI()
        self.configureUI()
        self.configureConstraints()
    }
    
    // MARK: - UI
    
    private func styleUI() {
        self.bottomBorderView.backgroundColor = .navigationBarBorderGray
    }
    
    private func configureUI() {
        self.bottomBorderView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.bottomBorderView)
    }
    
    private func configureConstraints() {
        ConstraintHelper.addHeightConstraint(view: self.bottomBorderView, constant: 0.5)
        ConstraintHelper.addBottomConstraint(subview: self.bottomBorderView, constant: -0.5, superview: self)
        ConstraintHelper.addLeftConstraint(subview: self.bottomBorderView, constant: 0.0, superview: self)
        ConstraintHelper.addRightConstraint(subview: self.bottomBorderView, constant: 0.0, superview: self)
    }
}
