//
//  Style.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 09.04.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit

extension UIColor {
    class func scholarsPurpleColor() -> UIColor {
        return UIColor(red: 118.0 / 255.0, green: 51.0 / 255.0, blue: 250.0 / 255.0, alpha: 1.0)
    }
}

extension UIButton {
    func applyScholarsButtonStyle() {
        self.layer.cornerRadius = 7
        self.layer.borderColor = UIColor.scholarsPurpleColor().CGColor
        self.layer.borderWidth = 0.5
        self.setTitleColor(UIColor.scholarsPurpleColor(), forState: UIControlState.Normal)
    }
}

extension UIView {
    func applyExtendedNavigationBarContainerStyle() {
        self.backgroundColor = UIColor.scholarsPurpleColor()
    }
}

extension UIViewController {
    func applyExtendedNavigationBarStyle() {
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.shadowImage = UIImage(named: "transparentPixel")
        let colouredImage = UIImage.imageWithSize(CGSize(width: 1, height: 1), color: UIColor.scholarsPurpleColor())
        self.navigationController?.navigationBar.setBackgroundImage(colouredImage, forBarMetrics: UIBarMetrics.Default)
    }
}