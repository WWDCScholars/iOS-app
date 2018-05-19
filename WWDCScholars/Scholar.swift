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

internal class Scholar {
    var id: CKRecordID?
	
    var firstName: String
    var lastName: String
    var gender: Gender
    var birthday: Date
    var location: CLLocation
    
    var email: String
    var shortBio: String
    
    var socialMediaRef: CKReference

    var batches: [String]
    var batchInfos: [CKReference]
    var approvedOn: Date?
    var createdAt: Date?
    var status : Status
    internal var profilePicture: CKAsset?
    internal var profilePictureLoaded: ((Error?) -> Void)? = nil
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    init(record: CKRecord) {
        id = record.recordID
        createdAt = record.creationDate
        
        location = record["location"] as! CLLocation
        shortBio = record["shortBio"] as! String
        gender = Gender(rawValue: record["gender"] as! String)!
        birthday = record["birthday"] as! Date
        email = record["email"] as! String
        lastName = record["lastName"] as! String
        firstName = record["firstName"] as! String
        
        socialMediaRef = record["socialMedia"] as! CKReference
        batches = (record["wwdcYears"] as! [CKReference]).map { $0.recordID.recordName }
        batchInfos = record["wwdcYearInfos"] as! [CKReference]

        status = Status(rawValue: record["status"] as! String)!
        approvedOn = record["approvedOn"] as? Date
        
        let maxBatch = self.batches.max(by: { a, b in
            let intOne = Int(a.replacingOccurrences(of: "WWDC ", with: ""))!
            let intTwo = Int(b.replacingOccurrences(of: "WWDC ", with: ""))!
            return intOne < intTwo
        })
		
        CloudKitManager.shared.loadWWDCBatchItem(in: batchInfos, for: maxBatch!, recordFetched: {
			rec in
            self.profilePicture = rec["profilePicture"] as? CKAsset
            self.profilePictureLoaded?(nil)
        })
    }
}
