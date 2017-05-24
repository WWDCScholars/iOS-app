//
//  ActivityFilterFactory.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 24/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import TwitterKit

internal final class ActivityFilterFactory {
    
    // MARK: - Lifecycle
    
    private init() {}
    
    // MARK: - Internal Functions
    
    internal static func filter(for activityTimelineFilters: [ActivityTimelineFilter]) -> TWTRTimelineFilter {
        var keywords = Set<AnyHashable>()
        var hashtags = Set<AnyHashable>()
        var handles = Set<AnyHashable>()
        var urls = Set<AnyHashable>()
        
        for filter in activityTimelineFilters {
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
        
        let filter = TWTRTimelineFilter()
        filter.keywords = keywords
        filter.hashtags = hashtags
        filter.handles = handles
        filter.urls = urls
        return filter
    }
}
