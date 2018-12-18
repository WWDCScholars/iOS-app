//
//  AppDelegate.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 13/04/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import UIKit
import Fabric
import TwitterKit
import Crashlytics
import Nuke

@UIApplicationMain
internal final class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Internal Properties
    
    internal var window: UIWindow?

    // MARK: - Internal Functions
    
    internal func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self, Twitter.self])

        UIStatusBar.applyScholarsLightStyle()
        UINavigationBar.applyScholarsStyle()
        UITabBar.applyScholarsStyle()
        
        ImagePipeline {
            $0.dataLoader = DataLoader(configuration: {
                // Disable disk caching built into URLSession
                let conf = DataLoader.defaultConfiguration
                conf.urlCache = nil
                return conf
            }())
            
            $0.imageCache = ImageCache()
            
            #if swift(>=4.2)
            $0.dataCache = try! DataCache(name: "com.github.kean.Nuke.DataCache")
//            #else
//            $0.dataCache = try! DataCache(
//                name: "com.github.kean.Nuke.DataCache",
//                filenameGenerator: {
//                    guard let data = $0.cString(using: .utf8) else { return nil }
//                    return _nuke_sha1(data, UInt32(data.count))
//            })
            #endif
        }
        
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
