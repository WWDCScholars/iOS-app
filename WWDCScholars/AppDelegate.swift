//
//  AppDelegate.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13/04/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import UIKit

@UIApplicationMain
internal final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Internal Properties
    
    internal var window: UIWindow?

    // MARK: - Internal Functions
    
    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIStatusBar.applyScholarsLightStyle()
        UINavigationBar.applyScholarsStyle()
        UITabBar.applyScholarsStyle()
        
        if let shortcutItem = launchOptions?[.shortcutItem] as? UIApplicationShortcutItem {
            let success = self.handle(shortcutItem: shortcutItem)
            return success
        }
        
        return true
    }
    
    internal func applicationWillResignActive(_ application: UIApplication) {
    }

    internal func applicationDidEnterBackground(_ application: UIApplication) {
    }

    internal func applicationWillEnterForeground(_ application: UIApplication) {
    }

    internal func applicationDidBecomeActive(_ application: UIApplication) {
    }

    internal func applicationWillTerminate(_ application: UIApplication) {
    }
    
    internal func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        let success = self.handle(shortcutItem: shortcutItem)
        completionHandler(success)
    }
    
    // MARK: - Private Functions
    
    private func handle(shortcutItem: UIApplicationShortcutItem) -> Bool {
        return QuickActionManager.shared.handle(shortcutItem: shortcutItem, rootViewController: self.window?.rootViewController)
    }
}
