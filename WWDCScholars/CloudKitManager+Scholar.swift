//
//  CloudKitManager+Scholar.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal typealias ListScholarFetched = ((BasicScholar, BatchInfo) -> Void)
internal typealias ScholarFetched = ((Scholar) -> Void)

internal extension CloudKitManager {
    
    // MARK: - Internal Functions
    
    internal func loadScholarsForList(in batchInfo: BatchInfo, with status: ScholarStatus, cursor: CKQueryCursor? = nil, recordFetched: @escaping ListScholarFetched, completion: QueryCompletion) {
        let recordID = CKRecordID(recordName: batchInfo.recordName)
        let yearReference = CKReference(recordID: recordID, action: .none)
        let predicateFormat = "status = '\(status.rawValue)' AND wwdcYears CONTAINS %@"
        let predicate = NSPredicate(format: predicateFormat, yearReference)
        
        let recordType = "Scholar"
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["recordID", "location", "firstName", "wwdcYears", "wwdcYearInfos"]
        operation.resultsLimit = CKQueryOperationMaximumResults
        operation.cursor = cursor
        operation.qualityOfService = .userInitiated
        operation.queryCompletionBlock = completion
        operation.recordFetchedBlock = { (record: CKRecord!) in
            let smallScholar = BasicScholar(record: record)
            recordFetched(smallScholar, batchInfo)
        }
        
        self.database.add(operation)
    }
    
    internal func loadScholar(with id: CKRecordID, recordFetched: @escaping ScholarFetched, completion: QueryCompletion) {
        let predicateFormat = "recordID = %@"
        let predicate = NSPredicate(format: predicateFormat, id)
        let recordType = "Scholar"
        let query = CKQuery(recordType: recordType, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 1
        operation.qualityOfService = .userInitiated
        operation.queryCompletionBlock = completion
        operation.recordFetchedBlock = { (record:CKRecord!) in
            let scholar = Scholar(record: record)
            recordFetched(scholar)
        }
        
        self.database.add(operation)
    }
}
