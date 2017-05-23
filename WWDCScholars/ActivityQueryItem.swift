//
//  ActivityQueryItem.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 22/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import CloudKit

class ActivityQueryItem {
    var value: String = ""
    var combinerTag: String = ""
    
    init(record: CKRecord) {
        self.value = record["value"] as! String
        self.combinerTag = record["combinerTag"] as! String
    }
}

extension CloudKitManager {
    internal func loadActivityQueryItems(completion: @escaping (String?, Error?) -> Void) {
        let query = CKQuery.init(recordType: "ActivityQueryItem", predicate: NSPredicate.init(value: true))
        CloudKitManager.shared.database.perform(query, inZoneWith: nil, completionHandler: { items, error in
            guard error == nil, let items = items else {
                completion(nil, error)
                return
            }
            
            let queryItems: [ActivityQueryItem] = items.map { ActivityQueryItem.init(record: $0) }
            var queryString = ""
            for (index, queryPart) in queryItems.enumerated() {
                if index != 0 {
                    queryString.append(queryPart.combinerTag + " ")
                }
                queryString.append(queryPart.value + " ")
            }
            completion(queryString, nil)
        })
    }
}
