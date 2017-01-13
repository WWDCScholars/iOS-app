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
            return Foundation.UserDefaults.standard.bool(forKey: "hasOpenedApp")
        }
        set(hasOpenedApp) {
            Foundation.UserDefaults.standard.set(hasOpenedApp, forKey: "hasOpenedApp")
        }
    }
    
    static var favorites: [String] {
        get {
            return Foundation.UserDefaults.standard.object(forKey: "favorites") as? [String] ?? []
        }
        set(favorites) {
            Foundation.UserDefaults.standard.set(favorites, forKey: "favorites")
        }
    }
}
