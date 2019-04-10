//
//  BatchInfo.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 12/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal enum WWDCYear: String {
    
    // MARK: - Cases
    
    case wwdc2013 = "WWDC 2013"
    case wwdc2014 = "WWDC 2014"
    case wwdc2015 = "WWDC 2015"
    case wwdc2016 = "WWDC 2016"
    case wwdc2017 = "WWDC 2017"
    case wwdc2018 = "WWDC 2018"
    case wwdc2019 = "WWDC 2019"
    case saved = "Saved"
    
    // MARK: - Internal Properties
    
    var title: String {
        return String(rawValue.split(separator: " ").last ?? "")
    }
    
    var shortYear: String {
        let year = String(rawValue.split(separator: " ").last ?? "")
        return String(year[2...])
    }
    
    var isDefault: Bool {
        if self == .wwdc2019 {
            return true
        }
        
        return false
    }
    
    var recordName: String {
        return self.rawValue
    }
    
}
