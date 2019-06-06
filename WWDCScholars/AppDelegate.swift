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
        
        ImagePipeline.shared = ImagePipeline {
            $0.dataLoader = DataLoader(configuration: {
                // Disable disk caching built into URLSession
                let conf = DataLoader.defaultConfiguration
                conf.urlCache = nil
                return conf
            }())
            
            $0.imageCache = ImageCache()

            $0.dataCache = try! DataCache(name: "com.wwdcscholars.profilepictures.DataCache")
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
    
    internal func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        // The following guard checks whether the NSUserActivity has to do with Universal Links
        // Might have to change when more NSUserActivity stuff is used inside the app
        
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL else {
                return false
        }
        
        let pathComponents = incomingURL.pathComponents
        
        print("path = \(incomingURL.path)")
        
        if pathComponents.count >= 3,
            pathComponents[1] == "s",
            let incomingId = pathComponents.last,
            let scholarId = UUID.init(uuidString: incomingId) {
            
            print("scholar = \(scholarId)")
            
            if self.window?.rootViewController?.presentedViewController != nil {
                self.window?.rootViewController?.dismiss(animated: false, completion: nil)
            }
            
            if let rootViewController = self.window?.rootViewController {
                rootViewController.presentProfileViewController(scholarId: scholarId.asRecordId())
            }
            
            return true
            
        } else {
            print("Either wrong first path item or scholar  UUID in wrong format")
            return false
        }
    }
    
    // MARK: - Private Functions
    
    private func handle(shortcutItem: UIApplicationShortcutItem) -> Bool {
        return QuickActionManager.shared.handle(shortcutItem: shortcutItem, rootViewController: self.window?.rootViewController)
    }
}
