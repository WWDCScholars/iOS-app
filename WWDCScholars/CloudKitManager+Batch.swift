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
        let year = CKReference.init(recordID: CKRecordID.init(recordName: year), action: .none)
        let predicate = NSPredicate(format: "recordID IN %@ AND year = %@", wwdcYearInfoRefs, year)
        let query = CKQuery(recordType: "WWDCYearInfo", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = keys // ["recordID", "profilePicture"]
        operation.resultsLimit = CKQueryOperationMaximumResults
        operation.qualityOfService = .userInteractive
        operation.queryCompletionBlock = completion
        operation.recordFetchedBlock = recordFetched
        self.database.add(operation)
    }
}
