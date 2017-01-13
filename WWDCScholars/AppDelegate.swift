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
import Alamofire
import AlamofireImage
import Firebase

//#if DEBUG
//import SimulatorStatusMagic
//#endif
//import CoreSpotlight
//import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var year:NSString!=""

    // 3D Touch
    enum ShortcutIdentifier: String {
        case OpenMyProfile
        case OpenFavorites
        case OpenBlog
        case OpenChat
        
        init?(fullIdentifier: String) {
            guard let shortIdentifier = fullIdentifier.components(separatedBy: ".").last else {
                return nil
            }
            
            self.init(rawValue: shortIdentifier)
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        var keys: NSDictionary?
        
        #if DEBUG
//            SDStatusBarManager.sharedInstance().enableOverrides()
        #endif
        
//        if let options = launchOptions {[[NSProcessInfo processInfo].environment hasKey:@"UITest"]
            if ProcessInfo.processInfo.environment.keys.contains("loggedInScholarId"){
                UserKit.sharedInstance.scholarId = ProcessInfo.processInfo.environment["loggedInScholarId"]
            }
//        }
        
        if let path = Bundle.main.path(forResource: "ServerDetails", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        } else {
            fatalError("File 'ServerDetails.plist' not found: Please create a ServerDetails.plist, add the server details to it and add it to the target")
        }
        
        if let dict = keys {
            let serverUrl = dict["serverUrl"] as? String
            let serverAPIKey = dict["serverAPIKey"] as? String
            
            if let serverUrl = serverUrl, let serverAPIKey = serverAPIKey {
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
        
        if let window = self.window {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let mainViewController = mainStoryboard.instantiateViewController(withIdentifier: String(describing: "ScholarsTabBarViewController"))
            
           // let mainViewController: ScholarsTabBarViewController = mainStoryboard.instantiateViewController(withIdentifier: String(describing: ScholarsTabBarViewController())) as! ScholarsTabBarViewController
            
            // Make it a root controller
            window.backgroundColor = UIColor.white
            window.rootViewController = mainViewController
            window.makeKeyAndVisible()
        }
        
//        ScholarsKit.sharedInstance.updateScholarData("56fc2ddaa5ac14970921ad6a", password: "Scholarsh1p2015", firstName: "Steve", lastName: "Even", shortBio: "This is Steven", profilePic: UIImage(named: "appstoreIconSmall"), screenshotOne: UIImage(named: "appstoreIconSmall"), screenshotTwo: UIImage(named: "appstoreIconSmall"), screenshotThree: UIImage(named: "appstoreIconSmall"), screenshotFour: UIImage(named: "appstoreIconSmall"))
        
        CreditsManager.sharedInstance.getCredits()
        Fabric.with([Crashlytics.self])
        FIRApp.configure()
        
        self.styleUI()
        
    
        let photoCache = AutoPurgingImageCache( memoryCapacity: 50 * 1024 * 1024, preferredMemoryUsageAfterPurge: 20 * 1024 * 1024 )
//
//        
//        let mng = Alamofire.SessionManager.default
//        
//        
        let newImageDownloader = ImageDownloader(downloadPrioritization: .fifo, maximumActiveDownloads: 50, imageCache: photoCache)
        UIImageView.af_sharedImageDownloader = newImageDownloader
        
        // 3D Touch
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            return self.handleShortcut(shortcutItem)
        }
        
        
        return true
    }
    
    // Core Spotlight
    /*func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        if userActivity.activityType == CSSearchableItemActionType {
            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                (self.window?.rootViewController as! ScholarsTabBarViewController).openScholarDetail(uniqueIdentifier)
            }
        }
        
        return true
    } */
    
    // 3D Touch
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem))
    }
    
    fileprivate func handleShortcut(_ shortcutItem: UIApplicationShortcutItem) -> Bool {
        let shortcutType = shortcutItem.type
        guard let shortcutIdentifier = ShortcutIdentifier(fullIdentifier: shortcutType) else {
            return false
        }
        
        return self.selectTabBarItemForIdentifier(shortcutIdentifier)
    }
    
    fileprivate func selectTabBarItemForIdentifier(_ identifier: ShortcutIdentifier) -> Bool {
        guard let tabBarController = self.window?.rootViewController as? UITabBarController else {
            return false
        }
        
        switch identifier {
        case .OpenMyProfile:
            
            
            tabBarController.selectedIndex = 0
            
            if (!UserKit.sharedInstance.isLoggedIn) {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let vc = storyboard.instantiateViewController(withIdentifier: "SignInVC")
                self.window?.rootViewController?.present(vc, animated: true, completion: nil)
            } else {
                
                let storyboard = UIStoryboard(name: "ScholarDetailVC", bundle: nil)
                
                let vc = storyboard.instantiateViewController(withIdentifier: "scholarDetailViewController") as! ScholarDetailViewController
                
                guard let detailViewController: ScholarDetailViewController = vc else {
                    return false
                }
                
                detailViewController.setScholar(UserKit.sharedInstance.scholarId!)
                // self.window?.rootViewController?.presentViewController(detailViewController, animated: true, completion: nil)
                ((self.window?.rootViewController as! UITabBarController).viewControllers![0] as! UINavigationController).pushViewController(detailViewController, animated: true)
            }
            
            return true
        case .OpenFavorites:
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.year = "saved"
            
            tabBarController.selectedIndex = 0
            
            let scholarsVC: ScholarsViewController = ((self.window?.rootViewController as! UITabBarController).viewControllers![0] as! UINavigationController).viewControllers[0] as! ScholarsViewController
            scholarsVC.changeYear(IndexPath(row: 6, section: 0))
            
            return true
        case .OpenBlog:
            tabBarController.selectedIndex = 1
            return true
        case .OpenChat:
            tabBarController.selectedIndex = 3
            return true
        }
    }
    
    @nonobjc internal func application(_ application: UIApplication, handleOpen url: String) -> Bool {
        
        /*
        if url.host == "scholar" {
            //todo check if id exists
            (self.window?.rootViewController as! ScholarsTabBarViewController).openScholarDetail(url.lastPathComponent!)
        } else if url.host == "post" {
            (self.window?.rootViewController as! ScholarsTabBarViewController).openScholarDetail(url.lastPathComponent!) // todo Open blog, not scholar
        }*/
        
        return true
    }
    
    fileprivate func styleUI() {
        UINavigationBar.applyNavigationBarStyle()
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}
