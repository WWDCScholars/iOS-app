//
//  BasicScholar.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

typealias ImageLoaded = ((Error?) -> Void)

internal final class BasicScholar: CloudKitInitializable {
    
    // MARK: - Internal Properties
    
    internal var id: CKRecordID
    internal let firstName: String
    internal let location: CLLocation
    private var latestBatch: String? = nil
    private var batchInfoReferences: [CKReference] = []
    internal var profilePicture: CKAsset?
	internal var profilePictureLoaded: [ImageLoaded] = []
	
    // MARK: - Lifecycle
    
    internal required init(record: CKRecord) {
        self.id = record.recordID
        self.location = record["location"] as! CLLocation
        self.firstName = record["firstName"] as! String
        
        guard let batchRefs = record["wwdcYears"] as? [CKReference] else {
            return
        }
        let batches = batchRefs.map { $0.recordID.recordName }
        let latestBatch = batches.max(by: { a, b in
            let intOne = Int(a.replacingOccurrences(of: "WWDC ", with: ""))!
            let intTwo = Int(b.replacingOccurrences(of: "WWDC ", with: ""))!
            return intOne < intTwo
        })
        self.latestBatch = latestBatch
        
        guard let batchInfoReferences = record["wwdcYearInfos"] as? [CKReference] else { return }
        self.batchInfoReferences = batchInfoReferences
        
        self.profilePicture = nil
    }
    
    internal func loadProfilePicture() {
        guard profilePicture == nil else {
            _ = self.profilePictureLoaded.map { $0(nil) }
            self.profilePictureLoaded = []
            return
        }
        
        guard let latestBatch = self.latestBatch else {
            return
        }
        CloudKitManager.shared.loadWWDCBatchItem(in: self.batchInfoReferences, for: latestBatch, with: ["profilePicture_small"], recordFetched: {
            rec in
            self.profilePicture = rec["profilePicture_small"] as? CKAsset
            _ = self.profilePictureLoaded.map{ $0(nil) }
            self.profilePictureLoaded = []
        })
    }
}
