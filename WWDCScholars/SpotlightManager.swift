//
//  SpotlightManager.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices

class SpotlightManager {
    static let sharedInstance = SpotlightManager()
    
    func indexScholar(scholar: Scholar, atIndex: Int) {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = scholar.fullName
        attributeSet.contentDescription = scholar.shortBio
        
        let item = CSSearchableItem(uniqueIdentifier: "\(atIndex)", domainIdentifier: "com.wwdcscholars", attributeSet: attributeSet)
        CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item]) { (error: NSError?) -> Void in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            } else {
                print("Search item successfully indexed!")
            }
        }
    }
}