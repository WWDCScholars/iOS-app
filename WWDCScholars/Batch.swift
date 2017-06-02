//
//  Batch.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal final class Batch: CloudKitInitializable {
    
    // MARK: - Internal Properties
    
    internal let id: CKRecordID
    internal let scholarReference: CKReference?
    internal let yearReference: CKReference
    internal let profilePicture: CKAsset
    internal let acceptanceEmail: CKAsset?
    internal let videoLink: String?
    internal let screenshots: [CKAsset]
    internal let githubAppLink: String?
    internal let appType: String?
    internal let appStoreSubmissionLink: String?
    internal let appliedAs: ApplicantType

    // MARK: - Lifecycle
    
    internal required init(record: CKRecord) {
        self.id = record.recordID
        self.scholarReference  = record["scholar"] as? CKReference
        self.yearReference = record["year"] as! CKReference
        self.profilePicture = record["profilePicture"] as! CKAsset
        self.acceptanceEmail = record["acceptanceEmail"] as! CKAsset?
        self.screenshots = record["screenshots"] as! [CKAsset]
        self.videoLink = record["videoLink"] as! String?
        self.githubAppLink = record["githubAppLink"] as! String?
        self.appType = record["appType"] as? String
        self.appStoreSubmissionLink = record["appStoreSubmissionLink"] as! String?
        self.appliedAs = ApplicantType(rawValue: record["appliedAs"] as! String) ?? .student
    }
}
