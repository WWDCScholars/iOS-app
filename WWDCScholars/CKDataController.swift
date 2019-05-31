//
//  CKDataController.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 18/12/2018.
//  Copyright © 2018 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

class CKDataController: ScholarDataController {
    func scholar(for id: UUID) -> Scholar? {
        return nil
    }
    
    // MARK: - Internal Properties
    
    internal static let shared = CKDataController()
    internal let container: CKContainer
    
    private var scholarFetched: ((CKRecord) -> ())! = { a in }
    private var queryCompleted: ((CKQueryOperation.Cursor?, Error?) -> ())! = { a, b in }

//    private let publicDatabase: CKDatabase
    
    private init() {
        self.container = CKContainer(identifier: "iCloud.com.cecose.WWDCScholars")
//        self.database = self.container.publicCloudDatabase
    }
    
    func scholars(for year: WWDCYear) -> [Scholar] {
        var loadedScholars: [Scholar] = []
        
        let sync = SyncBlock.init()
        let yearRef = CKRecord.Reference(recordID: CKRecord.ID.init(recordName: year.recordName), action: .none)
        let predicate = NSPredicate(format: "(wwdcYears CONTAINS %@) AND (wwdcYearsApproved CONTAINS %@) AND (gdprConsentAt <= %@)", yearRef, yearRef, NSDate())
        
        let query = CKQuery(recordType: "Scholar", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["socialMedia", "familyName", "givenName", "wwdcYears", "biography", "location", "birthday", "wwdcYearInfos", "email", "gender", "profilePicture"]
        operation.qualityOfService = .userInteractive
        
        scholarFetched = { (record:CKRecord!) in
            guard let scholar = Scholar(scholarRecord: record) else {
                print("loadScholars - Scholar could not be created")
                return
            }
            
            print ("Hello scholar \(scholar.id)")

            if !loadedScholars.contains(where: { $0.id == scholar.id }) {
                loadedScholars.append(scholar)
            } else {
                if let idx = loadedScholars.firstIndex(where: { $0.id == scholar.id }) {
                    loadedScholars.removeAll(where: { $0.id == scholar.id })
                    loadedScholars.insert(scholar, at: idx)
                }
            }
        }
        
        queryCompleted = { (cursor, error) in
            if let error = error {
                fatalError(error.localizedDescription)
                return
            }
            
            print ("Hello completion: done? \(cursor == nil)")
            
            if let cursor = cursor {
                let operation = CKQueryOperation(cursor: cursor)
                operation.desiredKeys = ["socialMedia", "familyName", "givenName", "wwdcYears", "biography", "location", "birthday", "wwdcYearInfos", "email", "gender", "profilePicture"]
                operation.qualityOfService = .userInteractive
                operation.recordFetchedBlock = self.scholarFetched
                operation.queryCompletionBlock = self.queryCompleted
                self.container.publicCloudDatabase.add(operation)
                
                print("Add")
            } else {
                sync.complete()
                print("Sync Complete")
            }
        }
        
        operation.queryCompletionBlock = self.queryCompleted
        operation.recordFetchedBlock = self.scholarFetched
        
        self.container.publicCloudDatabase.add(operation)
        
        sync.wait(seconds: 30)
        
        return loadedScholars
    }
    
    func scholar(for id: CKRecord.ID) -> Scholar? {
        var loadedScholar: Scholar? = nil
        
        let sync = SyncBlock.init()
        
        let operation = CKFetchRecordsOperation.init(recordIDs: [id])
        operation.desiredKeys = ["socialMedia", "familyName", "givenName", "wwdcYears", "biography", "location", "birthday", "wwdcYearInfos", "email", "gender", "profilePicture"]
        operation.qualityOfService = .userInteractive
        
        
            operation.fetchRecordsCompletionBlock = { (records, error) in
                guard error == nil,
                    let records = records,
                let record = records[id] else {
                    fatalError(error?.localizedDescription ?? "No records")
                    return
                }
                
                guard let scholar = Scholar(scholarRecord: record) else {
                    print("scholar for ID - Scholar could not be created")
                    return
                }
                
                print ("Hello scholar \(scholar.id)")
                
                loadedScholar = scholar
                
                sync.complete()
        }
        
        self.container.publicCloudDatabase.add(operation)
        
        sync.wait(seconds: 30)
        
        return loadedScholar
    }
    
    func scholarData(for year: WWDCYear, scholar: Scholar) -> WWDCYearInfo? {
        return nil
    }
    
    func countScholars(for year: WWDCYear?) -> Int {
        return 0
    }
    
    func add(_ scholar: Scholar) {
        fatalError("add(_ scholar:) has not been implemented")
    }
    
    func remove(_ scholar: Scholar) {
        fatalError("remove(_ scholar:) has not been implemented")
    }
    
    func update(_ scholar: Scholar) {
        fatalError("update(_ scholar:) has not been implemented")
    }
    
    
}
