//
//  UserDefaults.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 05/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

class UserDefaults {
    static var hasOpenedApp: Bool {
        get {
            return NSUserDefaults.standardUserDefaults().boolForKey("hasOpenedApp")
        }
        set(hasOpenedApp) {
            NSUserDefaults.standardUserDefaults().setObject(hasOpenedApp, forKey: "hasOpenedApp")
        }
    }
    
    static var favorites: [String] {
        get {
            return NSUserDefaults.standardUserDefaults().objectForKey("favorites") as? [String] ?? []
        }
        set(favorites) {
            NSUserDefaults.standardUserDefaults().setObject(favorites, forKey: "favorites")
        }
    }
}