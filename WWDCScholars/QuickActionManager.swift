//
//  QuickActionManager.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 18/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import UIKit

internal final class QuickActionManager {
    
    // MARK: - Internal Properties
    
    internal static let shared = QuickActionManager()
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Internal Functions
    
    internal func handle(shortcutItem: UIApplicationShortcutItem, rootViewController: UIViewController?) -> Bool {
        guard let quickActionShortcutType = QuickActionShortcutType(identifier: shortcutItem.type) else {
            return false
        }
        
        guard let tabBarController = rootViewController as? UITabBarController else {
            return false
        }
        
        switch quickActionShortcutType {
        case .OpenMyProfile:
            self.openProfile(tabBarController: tabBarController)
        case .OpenSavedScholars:
            self.openSavedScholars(tabBarController: tabBarController)
        case .OpenActivity:
            self.openAcivity(tabBarController: tabBarController)
        case .OpenBlog:
            self.openBlog(tabBarController: tabBarController)
        }
        
        return true
    }
    
    // MARK: - Private Functions
    
    private func openProfile(tabBarController: UITabBarController) {
        tabBarController.selectedIndex = 0
    }
    
    private func openSavedScholars(tabBarController: UITabBarController) {
        tabBarController.selectedIndex = 0
    }
    
    private func openAcivity(tabBarController: UITabBarController) {
        tabBarController.selectedIndex = 2
    }
    
    private func openBlog(tabBarController: UITabBarController) {
        tabBarController.selectedIndex = 3
    }
}
