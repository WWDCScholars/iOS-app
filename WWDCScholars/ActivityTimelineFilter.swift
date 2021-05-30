//
//  ActivityTimelineFilter.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 22/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal enum ActivityTimelineFilterType: String {
    case keyword
    case hashtag
    case handle
    case url
}

internal final class ActivityTimelineFilter {
    
    // MARK: - Internal Properties
    
    internal let type: ActivityTimelineFilterType
    internal let filter: String
    
    // MARK: - Lifecycle
    
    internal init(record: CKRecord) {
        self.type = ActivityTimelineFilterType(rawValue: record["type"] as! String)!
        self.filter = record["filter"] as! String
    }
}
