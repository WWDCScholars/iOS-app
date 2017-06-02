//
//  Scholar.swift
//  WWDCScholars
//
//  Created by Andrew Walker on 08/05/2017.
//  Copyright © 2017 Andrew Walker. All rights reserved.
//

import Foundation
import CoreLocation
import CloudKit

internal final class Scholar {
    
    // MARK: - Internal Properties
    
    internal let id: CKRecordID?
    internal let firstName: String
    internal let lastName: String
    internal let gender: Gender
    internal let birthday: Date
    internal let location: CLLocation
    internal let email: String
    internal let shortBio: String
    internal let socialMediaRef: CKReference
    internal let batches: [String]
    internal let batchInfos: [CKReference]
    internal let approvedOn: Date?
    internal let createdAt: Date?
    internal let status: ScholarStatus
    
    // MARK: - Lifecycle
    
    internal init(record: CKRecord) {
        self.id = record.recordID
        self.createdAt = record.creationDate
        self.location = record["location"] as! CLLocation
        self.shortBio = record["shortBio"] as! String
        self.gender = Gender(rawValue: record["gender"] as! String)!
        self.birthday = record["birthday"] as! Date
        self.email = record["email"] as! String
        self.lastName = record["lastName"] as! String
        self.firstName = record["firstName"] as! String
        self.socialMediaRef = record["socialMedia"] as! CKReference
        self.batches = (record["wwdcYears"] as! [CKReference]).map { $0.recordID.recordName }
        self.batchInfos = record["wwdcYearInfos"] as! [CKReference]
        self.status = ScholarStatus(rawValue: record["status"] as! String)!
        self.approvedOn = record["approvedOn"] as? Date
    }
}
