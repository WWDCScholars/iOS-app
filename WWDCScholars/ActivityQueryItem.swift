//
//  ActivityQueryItem.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 22/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal final class ActivityQueryItem {
    
    // MARK: - Internal Properties
    
    internal let value: String
    internal let combinerTag: String
    
    // MARK: - Lifecycle
    
    internal init(record: CKRecord) {
        self.value = record["value"] as! String
        self.combinerTag = record["combinerTag"] as! String
    }
}
