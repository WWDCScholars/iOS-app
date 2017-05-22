//
//  ActivityTimelineFilter.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 22/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import CloudKit
import TwitterKit

class ActivityTimelineFilter {
    enum `Type`: String {
        case keyword
        case hashtag
        case handle
        case url
    }
    
    var type: Type
    var filter: String
    
    init(record: CKRecord) {
        self.type = Type.init(rawValue: record["type"] as! String)!
        self.filter = record["filter"] as! String
    }
}

extension CloudKitManager {
    internal func loadActivityTimelineFilters(completion: @escaping (TWTRTimelineFilter?, Error?) -> Void) {
        let query = CKQuery.init(recordType: "ActivityTimelineFilter", predicate: NSPredicate.init(value: true))
        CloudKitManager.shared.database.perform(query, inZoneWith: nil, completionHandler: { items, error in
            guard error == nil, let items = items else {
                completion(nil, error)
                return
            }
            
            let queryItems: [ActivityTimelineFilter] = items.map { ActivityTimelineFilter.init(record: $0) }
            
            var keywords: Set<AnyHashable> = Set<AnyHashable>()
            var hashtags: Set<AnyHashable> = Set<AnyHashable>()
            var handles: Set<AnyHashable> = Set<AnyHashable>()
            var urls: Set<AnyHashable> = Set<AnyHashable>()
            
            for filter in queryItems {
                switch filter.type {
                case .keyword:
                    keywords.insert(filter.filter)
                    break
                case .hashtag:
                    hashtags.insert(filter.filter)
                    break
                case .handle:
                    handles.insert(filter.filter)
                    break
                case .url:
                    urls.insert(filter.filter)
                    break
                }
            }
            let filter = TWTRTimelineFilter.init()
            filter.keywords = keywords
            filter.hashtags = hashtags
            filter.handles = handles
            filter.urls = urls
            completion(filter, nil)
        })
    }
}
