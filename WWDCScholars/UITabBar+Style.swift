//
//  UITabBar+Style.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import UIKit

internal extension UITabBar {
    
    // MARK: - Internal Functions
    
    static func applyScholarsStyle() {
        self.appearance().tintColor = .tabBarTint
        self.appearance().isTranslucent = true
    }
}
