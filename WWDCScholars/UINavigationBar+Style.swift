//
//  UINavigationBar+Style.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    
    // MARK: - Internal Functions
    
    static func applyScholarsStyle() {
        self.appearance().tintColor = .white
        self.appearance().isTranslucent = false
        self.appearance().barTintColor = .scholarsPurple
        self.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func applyExtendedStyle() {
        let image = UIImage()
        self.setBackgroundImage(image, for: .default)
        self.shadowImage = image
    }
}
