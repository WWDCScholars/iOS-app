//
//  AppType.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 09/06/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

enum AppType: String {
    case Offline = "Offline"
    case AppStore = "AppStore"
    case Both = "Both"
    
    /**
     Returns the enum value for the string returned by the webserver
     
     - parameter rawValue: String returned by the webserver
     
     - returns: Enum value of AppType
     */
    static func forRawValue(rawValueOptional: String?) -> AppType {
        if let rawValue = rawValueOptional {
        switch rawValue {
        case "Offline":
            return .Offline
        case "AppStore":
            return .AppStore
        case "Both":
            return .Both
        default:
            return .Offline
        }
        }else {
            return .Offline
        }
    }
}
