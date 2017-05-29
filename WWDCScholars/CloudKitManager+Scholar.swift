//
//  CloudKitManager+Scholar.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal typealias ListScholarFetched = ((ListScholar) -> Void)
internal typealias ScholarFetched = ((Scholar) -> Void)

internal extension CloudKitManager {
    
    // MARK: - Internal Functions
    
    internal func loadScholarsForList(in batch: String, with status: Scholar.Status, cursor: CKQueryCursor? = nil, recordFetched: @escaping ListScholarFetched, completion: QueryCompletion) {
        let yearRef = CKReference.init(recordID: CKRecordID.init(recordName: batch), action: .none)
        let predicate = NSPredicate(format: "status == '\(status.rawValue)' AND wwdcYears CONTAINS %@", yearRef)
        let query = CKQuery(recordType: "Scholar", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["recordID", "location", "firstName", "wwdcYears", "wwdcYearInfos"]
        operation.resultsLimit = CKQueryOperationMaximumResults
        operation.cursor = cursor
        operation.qualityOfService = .userInitiated
        
        operation.queryCompletionBlock = completion
        
        operation.recordFetchedBlock = { (record:CKRecord!) in
            let smallScholar = ListScholar.init(record: record)
            recordFetched(smallScholar)
        }
        
        self.database.add(operation)
    }
    
    internal func loadScholar(with id: CKRecordID, recordFetched: @escaping ScholarFetched, completion: QueryCompletion) {
        let predicate = NSPredicate(format: "recordID = %@", id)
        let query = CKQuery(recordType: "Scholar", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 1
        operation.qualityOfService = .userInitiated
        
        operation.queryCompletionBlock = { cursor, err in
            print ("\(err.debugDescription)")
        }
        
        operation.recordFetchedBlock = { (record:CKRecord!) in
            let scholar = Scholar.init(record: record)
            recordFetched(scholar)
        }
        
        self.database.add(operation)
    }
}
