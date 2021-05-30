//
//  ActivityViewControllerProxy.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 24/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation

protocol ActivityViewControllerProxyDelegate: AnyObject {
    var proxy: ActivityViewControllerProxy? { get set }
    
    func didLoadActivityTimelineFilters(activityTimelineFilters: [ActivityTimelineFilter])
    func failedToLoadActivityTimelineFilters()
    func didLoadActivityQueryItems(activityQueryItems: [ActivityQueryItem])
    func failedToLoadActivityQueryItems()
}

final class ActivityViewControllerProxy {
    
    // MARK: - Private Properties
    
    private weak var delegate: ActivityViewControllerProxyDelegate?
    
    // MARK: - Lifecycle
    
    init(delegate: ActivityViewControllerProxyDelegate) {
        self.delegate = delegate
    }
    
    // MARK: - Internal Functions
    
    func loadActivityQueryItems() {
        CloudKitManager.shared.loadActivityQueryItems { (activityQueryItems, error) in
            guard let activityQueryItems = activityQueryItems else {
                self.delegate?.failedToLoadActivityQueryItems()
                return
            }
            
            self.delegate?.didLoadActivityQueryItems(activityQueryItems: activityQueryItems)
        }
    }
    
    func loadActivityTimelineFilters() {
        CloudKitManager.shared.loadActivityTimelineFilters { (activityTimelineFilters, error) in
            guard let activityTimelineFilters = activityTimelineFilters else {
                self.delegate?.failedToLoadActivityTimelineFilters()
                return
            }
            
            self.delegate?.didLoadActivityTimelineFilters(activityTimelineFilters: activityTimelineFilters)
        }
    }
}
