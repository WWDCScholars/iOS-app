//
//  ConstraintHelper.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class ConstraintHelper {
    
    // MARK: - Internal Functions
    
    internal static func addTopConstraint(subview: UIView, constant: CGFloat, superview: UIView) {
        let top = superview.topAnchor.constraint(equalTo: subview.topAnchor, constant: -constant)
        superview.addConstraint(top)
    }
    
    internal static func addBottomConstraint(subview: UIView, constant: CGFloat, superview: UIView) {
        let bottom = superview.bottomAnchor.constraint(equalTo: subview.bottomAnchor, constant: constant)
        superview.addConstraint(bottom)
    }
    
    internal static func addLeftConstraint(subview: UIView, constant: CGFloat, superview: UIView) {
        let left = superview.leftAnchor.constraint(equalTo: subview.leftAnchor, constant: -constant)
        superview.addConstraint(left)
    }
    
    internal static func addRightConstraint(subview: UIView, constant: CGFloat, superview: UIView) {
        let right = superview.rightAnchor.constraint(equalTo: subview.rightAnchor, constant: constant)
        superview.addConstraint(right)
    }
    
    internal static func addMarginConstraints(subview: UIView, edgeInsets: UIEdgeInsets, superview: UIView) {
        self.addTopConstraint(subview: subview, constant: edgeInsets.top, superview: superview)
        self.addBottomConstraint(subview: subview, constant: edgeInsets.bottom, superview: superview)
        self.addLeftConstraint(subview: subview, constant: edgeInsets.left, superview: superview)
        self.addRightConstraint(subview: subview, constant: edgeInsets.right, superview: superview)
    }
    
    internal static func addHeightConstraint(view: UIView, constant: CGFloat) {
        let height = view.heightAnchor.constraint(equalToConstant: constant)
        view.addConstraint(height)
    }
    
    internal static func addWidthConstraint(view: UIView, constant: CGFloat) {
        let width = view.widthAnchor.constraint(equalToConstant: constant)
        view.addConstraint(width)
    }
    
    internal static func addSizeConstraints(view: UIView, size: CGSize) {
        self.addWidthConstraint(view: view, constant: size.width)
        self.addHeightConstraint(view: view, constant: size.height)
    }
    
    internal static func addHorizontalCenterConstraint(subview: UIView, constant: CGFloat, superview: UIView) {
        let horizontalCenter = NSLayoutConstraint(item: subview, attribute: .centerX, relatedBy: .equal, toItem: superview, attribute: .centerX, multiplier: 1.0, constant: constant)
        superview.addConstraint(horizontalCenter)
    }
    
    internal static func addVerticalCenterConstraint(subview: UIView, constant: CGFloat, superview: UIView) {
        let verticalCenter = NSLayoutConstraint(item: subview, attribute: .centerY, relatedBy: .equal, toItem: superview, attribute: .centerY, multiplier: 1.0, constant: constant)
        superview.addConstraint(verticalCenter)
    }
    
    internal static func addCenterConstraints(subview: UIView, superview: UIView) {
        self.addHorizontalCenterConstraint(subview: subview, constant: 0.0, superview: superview)
        self.addVerticalCenterConstraint(subview: subview, constant: 0.0, superview: superview)
    }
    
}
