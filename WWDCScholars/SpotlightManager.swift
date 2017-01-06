//
//  SpotlightManager.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 14/05/2016.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices

extension Scholar {
    internal var userActivityUserInfo: [AnyHashable: Any] {
        return ["id": self.id]
    }
}

class SpotlightManager {
    static let sharedInstance = SpotlightManager()
    
    func indexScholar(_ scholar: Scholar, atIndex: Int) {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = scholar.fullName
        attributeSet.contentDescription = scholar.shortBio
        
        let item = CSSearchableItem(uniqueIdentifier: scholar.userActivityUserInfo["id"] as? String, domainIdentifier: "com.wwdcscholars", attributeSet: attributeSet)
        CSSearchableIndex.default().indexSearchableItems([item]) { (error: NSError?) -> Void in
            if let error = error {
                print("Indexing error: \(error.localizedDescription)")
            }
        }
    }
}
