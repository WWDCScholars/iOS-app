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
