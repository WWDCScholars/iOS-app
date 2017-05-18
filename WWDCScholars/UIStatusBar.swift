//
//  UIStatusBar.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class UIStatusBar {
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Internal Functions
    
    internal static func applyScholarsLightStyle() {
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    internal static func applyScholarsDarkStyle() {
        UIApplication.shared.statusBarStyle = .default
    }
}
