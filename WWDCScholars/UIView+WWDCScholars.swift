//
//  UIView+WWDCScholars.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 06/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal extension UIView {
    
    // MARK: - Internal Functions
    
    internal func roundCorners() {
        let cornerRadius = min(self.frame.height / 2, self.frame.width / 2)
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
    }
    
    internal func applyDefaultCornerRadius() {
        self.layer.cornerRadius = 10.0
        self.clipsToBounds = true
    }
    
    internal func applyRelativeCircularBorder() {
        let scale = self.frame.height / CircularViewBorderConstants.baselineScale
        let width = CircularViewBorderConstants.width * scale
        self.addExternalBorder(width: width, color: .white)
    }
}

internal extension UIView {
    
    // MARK: - Internal Structs
    
    internal struct CircularViewBorderConstants {
        internal static let width: CGFloat = 5.0
        internal static let baselineScale: CGFloat = 100.0
        internal static let identifier = "externalBorder"
    }
    
    // MARK: - Internal Functions
    
    internal func addExternalBorder(width: CGFloat, color: UIColor) {
        let viewSize = self.frame.size
        let externalBorderLayerWidth = viewSize.width + (2 * width)
        let externalBorderLayerHeight = viewSize.height + (2 * width)
        
        let externalBorderLayer = CALayer()
        externalBorderLayer.frame = CGRect(x: -width, y: -width, width: externalBorderLayerWidth, height: externalBorderLayerHeight)
        externalBorderLayer.borderColor = color.cgColor
        externalBorderLayer.borderWidth = width
        externalBorderLayer.name = CircularViewBorderConstants.identifier
        externalBorderLayer.cornerRadius = externalBorderLayerHeight / 2
    
        self.clipsToBounds = false
        self.layer.insertSublayer(externalBorderLayer, at: 0)
    }
    
    internal func removeExternalBorder() {
        let externalBorder = self.layer.sublayers?.filter({ $0.name == CircularViewBorderConstants.identifier }).first
        externalBorder?.removeFromSuperlayer()
    }
}
