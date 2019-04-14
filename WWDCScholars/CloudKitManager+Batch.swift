//
//  CloudKitManager+WWDCYearInfo.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

extension CloudKitManager {
    
    // MARK: - Internal Functions
    
    internal func loadWWDCWWDCYearInfoItem(in wwdcYearInfoRefs: [CKRecord.Reference], `for` year: String, with keys: [String]? = nil, recordFetched: @escaping RecordFetched, completion: QueryCompletion = nil) {
        let year = CKRecord.Reference(recordID: CKRecord.ID(recordName: year), action: .none)
        let predicate = NSPredicate(format: "recordID IN %@ AND year = %@", wwdcYearInfoRefs, year)
        let query = CKQuery(recordType: "WWDCYearInfo", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = keys // ["recordID", "profilePicture"]
        operation.resultsLimit = CKQueryOperation.maximumResults
        operation.qualityOfService = .userInteractive
        operation.queryCompletionBlock = completion
        operation.recordFetchedBlock = recordFetched
        self.database.add(operation)
    }
    
}
