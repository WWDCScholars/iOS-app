//
//  HoverBarShadowLayer.swift
//  WWDCScholars
//
//  Created by Moritz Sternemann on 22.09.19.
//  Copyright © 2019 WWDCScholars. All rights reserved.
//

import UIKit

final class HoverBarShadowLayer: CALayer {

    // MARK: - Properties
    override var cornerRadius: CGFloat {
        didSet { updateShadowPathAndMask() }
    }

    // MARK: Sublayers
    var maskShapeLayer: CAShapeLayer!

    // MARK: - Initializers
    override init() {
        super.init()
        commonInit()
    }

    override init(layer: Any) {
        super.init(layer: layer)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit() {
        let maskLayer = CAShapeLayer()
        maskShapeLayer = maskLayer
        maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        maskLayer.fillColor = UIColor.black.cgColor
        mask = maskLayer
        shadowOffset = .zero
    }

    // MARK: - Layout

    override func layoutSublayers() {
        super.layoutSublayers()
        self.updateShadowPathAndMask()
    }

    var bezierPathForShadow: UIBezierPath {
        return UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    }

    func updateShadowPathAndMask() {
        guard bounds.size.width > 0, bounds.size.height > 0 else { return }
        let shadowPath = bezierPathForShadow
        self.shadowPath = shadowPath.cgPath

        // using the even odd fill rule we create a path that includes the shadow which contains a path that excludes this layer's shadow path
        let outsetForShadow = -1 * (abs(shadowOffset.height) + abs(shadowOffset.width) + shadowRadius * 2)

        let maskPath = UIBezierPath(rect: bounds.inset(by: UIEdgeInsets(top: outsetForShadow, left: outsetForShadow, bottom: outsetForShadow, right: outsetForShadow)))
        maskPath.append(shadowPath)
        maskShapeLayer.frame = bounds
        maskShapeLayer.path = maskPath.cgPath
    }
}

