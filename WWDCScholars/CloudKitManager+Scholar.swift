//
//  CloudKitManager+Scholar.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal typealias ListScholarFetched = ((Scholar) -> Void)
internal typealias BlogScholarFetched = ListScholarFetched
internal typealias ScholarFetched = ((Scholar) -> Void)

internal extension CloudKitManager {
    
    // MARK: - Internal Functions
    
    internal func loadScholarsForList(in batchInfo: WWDCYear, with status: Scholar.Status, cursor: CKQueryOperation.Cursor? = nil, recordFetched: @escaping ListScholarFetched, completion: QueryCompletion) {
        let recordName = batchInfo.recordName
        let yearRef = CKRecord.Reference(recordID: CKRecord.ID.init(recordName: recordName), action: .none)
        let predicate = NSPredicate(format: "status = '\(status.rawValue)' AND wwdcYears CONTAINS %@", yearRef)
        let query = CKQuery(recordType: "Scholar", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["recordID", "location", "firstName", "wwdcYears", "wwdcYearInfos"]
        operation.resultsLimit = CKQueryOperation.maximumResults
        operation.cursor = cursor
        operation.qualityOfService = .userInteractive
        
        operation.queryCompletionBlock = completion
        
        operation.recordFetchedBlock = { (record:CKRecord!) in
//            let smallScholar = Scholar(record: record)
//            recordFetched(smallScholar)
        }
        
        self.database.add(operation)
    }
    
    internal func loadScholar(with id: CKRecord.ID, recordFetched: @escaping ScholarFetched, completion: QueryCompletion) {
        let predicate = NSPredicate(format: "recordID = %@", id)
        let query = CKQuery(recordType: "Scholar", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.resultsLimit = 1
        operation.qualityOfService = .userInteractive
        
        operation.queryCompletionBlock = { cursor, err in
            print ("\(err.debugDescription)")
        }
        
        operation.recordFetchedBlock = { (record:CKRecord!) in
//            let scholar = Scholar.init(record: record)
//            recordFetched(scholar)
        }
        
        self.database.add(operation)
    }
    
    internal func loadScholarsForBlog(with id: CKRecord.ID, recordFetched: @escaping BlogScholarFetched, completion: QueryCompletion) {
        let predicate = NSPredicate(format: "recordID = %@", id)
        let query = CKQuery(recordType: "Scholar", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["recordID", "location", "firstName", "wwdcYears", "wwdcYearInfos"]
        operation.resultsLimit = CKQueryOperation.maximumResults
        operation.resultsLimit = 1
        operation.qualityOfService = .userInteractive
        
        operation.queryCompletionBlock = completion
        
        operation.recordFetchedBlock = { (record:CKRecord!) in
//            let smallScholar = BasicScholar(record: record)
//            recordFetched(smallScholar)
        }
        
        self.database.add(operation)
    }

}
