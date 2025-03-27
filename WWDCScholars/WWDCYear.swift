//
//  WWDCYearInfoInfo.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 12/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal enum WWDCYear: String, CaseIterable {
    
    // MARK: - Cases
    
    case wwdc2013 = "WWDC 2013"
    case wwdc2014 = "WWDC 2014"
    case wwdc2015 = "WWDC 2015"
    case wwdc2016 = "WWDC 2016"
    case wwdc2017 = "WWDC 2017"
    case wwdc2018 = "WWDC 2018"
    case wwdc2019 = "WWDC 2019"
    case wwdc2020 = "WWDC 2020"
    case wwdc2021 = "WWDC 2021"
    case wwdc2022 = "WWDC 2022"
    case wwdc2023 = "WWDC 2023"
    case wwdc2024 = "WWDC 2024"
    case wwdc2025 = "WWDC 2025"
    
    // MARK: - Internal Properties
    
    var title: String {
        return String(rawValue.split(separator: " ").last ?? "")
    }
    
    var shortYear: String {
        let year = String(rawValue.split(separator: " ").last ?? "")
        return String(year[2...])
    }
    
    var isDefault: Bool {
        let last = WWDCYear.allCases
            .sorted(by: { $0.rawValue.compare($1.rawValue) == .orderedAscending })
            .last
        
        return self == last
    }
    
    var recordName: String {
        return self.rawValue
    }
    
}
