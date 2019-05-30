//
//  CloudKitManager+SocialMedia.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 03/06/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal typealias SocialMediaFetched = ((SocialMedia) -> Void)

internal extension CloudKitManager {
    
    // MARK: - Internal Functions
    
    internal func loadSocialMedia(with id: CKRecord.ID, recordFetched: @escaping SocialMediaFetched, completion: QueryCompletion) {
        let predicate = NSPredicate(format: "recordID = %@", id)
        let query = CKQuery(recordType: "ScholarSocialMedia", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 1
        operation.qualityOfService = .userInteractive
        
        operation.queryCompletionBlock = completion
        
        operation.recordFetchedBlock = { (record:CKRecord!) in
            let err = record["ww"]
            
            let socialMedia = SocialMedia.init(record: record)
            recordFetched(socialMedia)
        }
        
        self.database.add(operation)
    }
}
