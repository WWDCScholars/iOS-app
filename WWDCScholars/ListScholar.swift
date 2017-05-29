//
//  ListS.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

typealias ProfilePictureLoaded = ((_ error: Error?) -> Void)

internal class ListScholar {
    var id: CKRecordID?
    
    var firstName: String
    var profilePicture: CKAsset? = nil
    var location: CLLocation
    var profilePictureLoadedCallback: ProfilePictureLoaded? = nil
    
    init(record: CKRecord) {
        id = record.recordID
        location = record["location"] as! CLLocation
        firstName = record["firstName"] as! String
        let batchInfoRefs = record["wwdcYearInfos"] as! [CKReference]
        
        let batches = (record["wwdcYears"] as! [CKReference]).map { $0.recordID.recordName }
        let maxBatch = batches.max(by: { a, b in
            let intOne = Int(a.replacingOccurrences(of: "WWDC ", with: ""))!
            let intTwo = Int(b.replacingOccurrences(of: "WWDC ", with: ""))!
            return intOne < intTwo
        })
        
        CloudKitManager.shared.loadWWDCBatchItem(in: batchInfoRefs, for: maxBatch!, with: ["recordID", "profilePicture"], recordFetched: { rec in
            self.profilePicture = rec["profilePicture"] as? CKAsset
            print ("Loaded pic! \(self.profilePicture)")
            self.profilePictureLoadedCallback?(nil)
        }, completion: { _, error in
            self.profilePictureLoadedCallback?(error)
        })
        
        print ("Hi scholar \(self)")
    }
}
