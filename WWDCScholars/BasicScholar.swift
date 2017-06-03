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
    internal var profilePicture: CKAsset?
    internal var profilePictureLoaded: ((Error?) -> Void)? = nil
    // MARK: - Lifecycle
    
    internal required init(record: CKRecord) {
        self.id = record.recordID
        self.location = record["location"] as! CLLocation
        self.firstName = record["firstName"] as! String
        
        let batchInfoRefs = record["wwdcYearInfos"] as! [CKReference]
        
        let batches = (record["wwdcYears"] as! [CKReference]).map { $0.recordID.recordName }
        let maxBatch = batches.max(by: { a, b in
            let intOne = Int(a.replacingOccurrences(of: "WWDC ", with: ""))!
            let intTwo = Int(b.replacingOccurrences(of: "WWDC ", with: ""))!
            return intOne < intTwo
        })
        
        CloudKitManager.shared.loadWWDCBatchItem(in: batchInfoRefs, for: maxBatch!, recordFetched: { rec in
            self.profilePicture = rec["profilePicture"] as? CKAsset
            self.profilePictureLoaded?(nil)
        })
        
    }
}
