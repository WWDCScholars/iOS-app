//
//  BasicScholar.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal final class BasicScholar: CloudKitInitializable {
    
    // MARK: - Internal Properties
    
    internal var id: CKRecordID
    internal let firstName: String
    internal let location: CLLocation
    
    // MARK: - Lifecycle
    
    internal required init(record: CKRecord) {
        self.id = record.recordID
        self.location = record["location"] as! CLLocation
        self.firstName = record["firstName"] as! String
    }
}
