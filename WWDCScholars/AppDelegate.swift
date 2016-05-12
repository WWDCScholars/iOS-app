//
//  AppDelegate.swift
//  WWDCScholars
//
//  Created by Sam Eckert on 27.02.16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    // 3D Touch
    enum ShortcutIdentifier: String {
        case OpenMyProfile
        case OpenFavorites
        case OpenBlog
        case OpenChat
        
        init?(fullIdentifier: String) {
            guard let shortIdentifier = fullIdentifier.componentsSeparatedByString(".").last else {
                return nil
            }
            self.init(rawValue: shortIdentifier)
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        var keys: NSDictionary?
        
        if let path = NSBundle.mainBundle().pathForResource("ServerDetails", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        } else {
            fatalError("File 'ServerDetails.plist' not found: Please create a ServerDetails.plist, add the server details to it and add it to the target")
        }
        
        if let dict = keys {
            let serverUrl = dict["serverUrl"] as? String
            let serverAPIKey = dict["serverAPIKey"] as? String
            
            if let serverUrl = serverUrl, serverAPIKey = serverAPIKey {
                if serverUrl == "ENTER SERVER URL HERE" || serverAPIKey == "ENTER SERVER API KEY HERE"{
                    fatalError("No server data entered in the 'ServerDetails.plist' file. Make sure you are using the correct keys.")
                } else {
                    ApiBase.setServerDetails(serverUrl, serverAPIKey: serverAPIKey)
                }
            } else {
                fatalError("Server data entered in the 'ServerDetails.plist' file missing keys. Make sure you are using the correct keys.")
            }
        } else {
            fatalError("No server data entered in the 'ServerDetails.plist' file. Make sure you are using the correct keys.")
        }
        
        CreditsManager.sharedInstance.getCredits()
        Fabric.with([Crashlytics.self])
        
        self.styleUI()
        
        if let window = self.window {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            var contentVC: UIViewController?
            
            if UserDefaults.hasOpenedApp {
                let mainViewController: ScholarsTabBarViewController = mainStoryboard.instantiateViewControllerWithIdentifier(String(ScholarsTabBarViewController)) as! ScholarsTabBarViewController
                contentVC = mainViewController
            } else {
                let introViewController: IntroViewController = mainStoryboard.instantiateViewControllerWithIdentifier(String(IntroViewController)) as! IntroViewController
                contentVC = introViewController
            }
            
            // Make it a root controller
            
            window.backgroundColor = UIColor.whiteColor()
            window.rootViewController = contentVC
            window.makeKeyAndVisible()
        }
        
        
        // 3D Touch
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
            handleShortcut(shortcutItem)
            return false
        }
        
        return true
    }
    
    
    // 3D Touch
    func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem))
    }
    
    private func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = ShortcutIdentifier(fullIdentifier: shortcutType) else {
            return false
        }
        
        return selectTabBarItemForIdentifier(shortcutIdentifier)
    }
    
    private func selectTabBarItemForIdentifier(identifier: ShortcutIdentifier) -> Bool {
        guard let tabBarController = self.window?.rootViewController as? UITabBarController else {
            return false
        }
        
        switch (identifier) {
        case .OpenMyProfile:
            tabBarController.selectedIndex = 4
            print("insert myProfileView")
            return true
        case .OpenFavorites:
            tabBarController.selectedIndex = 3
            print("insert FavoriteView")
            return true
        case .OpenBlog:
            tabBarController.selectedIndex = 1
            return true
        case .OpenChat:
            tabBarController.selectedIndex = 3
            return true
        }
    }
    
    private func styleUI() {
        UINavigationBar.applyNavigationBarStyle()
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}

