//
//  BasicScholar.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal final class BasicScholar {
    
    // MARK: - Internal Properties
    
    internal let recordID: CKRecordID?
    internal let firstName: String
    internal let location: CLLocation
    
    // MARK: - Lifecycle
    
    internal init(record: CKRecord) {
        self.recordID = record.recordID
        self.location = record["location"] as! CLLocation
        self.firstName = record["firstName"] as! String
    }
}
