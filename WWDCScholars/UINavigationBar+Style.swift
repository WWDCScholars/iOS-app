//
//  UINavigationBar+Style.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal extension UINavigationBar {
    
    // MARK: - Internal Functions
    
    internal static func applyScholarsStyle() {
        self.appearance().tintColor = .white
        self.appearance().isTranslucent = false
        self.appearance().barTintColor = .scholarsPurple
        self.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
    }
    
    internal func applyExtendedStyle() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .default)
        self.shadowImage = image
    }
    
}
