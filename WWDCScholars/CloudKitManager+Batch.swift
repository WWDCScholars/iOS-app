//
//  CloudKitManager+Batch.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

extension CloudKitManager {
    
    // MARK: - Internal Functions
    
    internal func loadWWDCBatchItem(in wwdcYearInfoRefs: [CKReference], `for` year: String, with keys: [String]? = nil, recordFetched: @escaping RecordFetched, completion: QueryCompletion = nil) {
        let recordID = CKRecordID(recordName: year)
        let year = CKReference(recordID: recordID, action: .none)
        let predicateFormat = "recordID IN %@ AND year = %@"
        let predicate = NSPredicate(format: predicateFormat, wwdcYearInfoRefs, year)
        let recordType = "WWDCYearInfo"
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = keys
        operation.resultsLimit = CKQueryOperationMaximumResults
        operation.qualityOfService = .userInitiated
        operation.queryCompletionBlock = completion
        operation.recordFetchedBlock = recordFetched
        
        self.database.add(operation)
    }
}
