//
//  ActivityQueryFactory.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 24/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal final class ActivityQueryFactory {
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Internal Functions
    
    internal static func query(for activityQueryItems: [ActivityQueryItem]) -> String {
        var query = ""
        for (index, queryItem) in activityQueryItems.enumerated() {
            if index != 0 {
                query.append(queryItem.combinerTag + " ")
            }
            query.append(queryItem.value + " ")
        }
        return query
    }
}
