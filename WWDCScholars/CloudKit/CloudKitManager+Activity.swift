//
//  CloudKitManager+Activity.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal extension CloudKitManager {
    
    // MARK: - Internal Functions
    
    internal func loadActivityTimelineFilters(completion: @escaping ([ActivityTimelineFilter]?, Error?) -> Void) {
        let recordType = "ActivityTimelineFilter"
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        CloudKitManager.shared.database.perform(query, inZoneWith: nil, completionHandler: { items, error in
            guard let items = items, error == nil else {
                completion(nil, error)
                return
            }
            
            let activityTimelineFilters = items.map({ ActivityTimelineFilter(record: $0) })
            completion(activityTimelineFilters, nil)
        })
    }
}

internal extension CloudKitManager {
    
    // MARK: - Internal Functions
    
    internal func loadActivityQueryItems(completion: @escaping ([ActivityQueryItem]?, Error?) -> Void) {
        let recordType = "ActivityQueryItem"
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: recordType, predicate: predicate)
        CloudKitManager.shared.database.perform(query, inZoneWith: nil, completionHandler: { items, error in
            guard let items = items, error == nil else {
                completion(nil, error)
                return
            }
            
            let activityQueryItems = items.map({ ActivityQueryItem(record: $0) })
            completion(activityQueryItems, nil)
        })
    }
}
