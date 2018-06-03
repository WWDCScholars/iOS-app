//
//  Batch.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal class Batch: CloudKitInitializable {
    internal var id: CKRecordID
    
    internal var scholarReference: CKReference?
    internal var yearReference: CKReference
    
    internal let profilePicture: CKAsset
    internal let acceptanceEmail: CKAsset?
    internal let videoLink: String?
    internal let screenshots: [CKAsset] //Screenshots
    internal let githubAppLink: String?
    
    internal let appType: String?
    internal let appStoreSubmissionLink: String?
    
    internal let appliedAs: ApplicantType

    required init(record: CKRecord) {
        id = record.recordID
        scholarReference  = record["scholar"] as? CKReference
        yearReference = record["year"] as! CKReference
        profilePicture = record["profilePicture"] as! CKAsset
        acceptanceEmail = record["acceptanceEmail"] as! CKAsset?
        screenshots = record["screenshots"] as! [CKAsset]
        videoLink = record["videoLink"] as! String?
        githubAppLink = record["githubAppLink"] as! String?
        appType = record["appType"] as? String
        appStoreSubmissionLink = record["appStoreSubmissionLink"] as! String?
        appliedAs = ApplicantType(rawValue: record["appliedAs"] as! String) ?? .student
    }
    
}
