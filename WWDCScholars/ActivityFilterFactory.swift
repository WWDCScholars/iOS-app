//
//  ActivityFilterFactory.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 24/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

internal final class ActivityFilterFactory {
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Internal Functions
    
    internal static func filter(for activityTimelineFilters: [ActivityTimelineFilter]) -> Never {
        var keywords = Set<AnyHashable>()
        var hashtags = Set<AnyHashable>()
        var handles = Set<AnyHashable>()
        var urls = Set<AnyHashable>()

        for filter in activityTimelineFilters {
            switch filter.type {
            case .keyword:
                _ = keywords.insert(filter.filter)
                break
            case .hashtag:
                _ = hashtags.insert(filter.filter)
                break
            case .handle:
                _ = handles.insert(filter.filter)
                break
            case .url:
                _ = urls.insert(filter.filter)
                break
            }
        }

        fatalError()

//        let filter = TWTRTimelineFilter()
//        filter.keywords = keywords
//        filter.hashtags = hashtags
//        filter.handles = handles
//        filter.urls = urls
//        return filter
    }
}
