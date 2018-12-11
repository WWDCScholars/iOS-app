//
//  CloudKitManager+Scholar.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit

internal typealias ScholarFetched = ((Scholar) -> Void)

internal extension CloudKitManager {
    
    // MARK: - Internal Functions
    
    internal func loadScholars(`for` batch: WWDCYear, with status: Scholar.Status, recordFetched: @escaping ScholarFetched, completion: QueryCompletion) {
        let recordName = batch.recordName
        let yearRef = CKReference(recordID: CKRecordID.init(recordName: recordName), action: .none)
        let predicate = NSPredicate(format: "status = '\(status.rawValue)' AND wwdcYears CONTAINS %@", yearRef)
        let query = CKQuery(recordType: "Scholar", predicate: predicate)
        let operation = CKQueryOperation(query: query)
//        operation.desiredKeys = ["recordID", "location", "firstName", "wwdcYears", "wwdcYearInfos"]
        operation.resultsLimit = CKQueryOperationMaximumResults
        operation.qualityOfService = .userInteractive
        
        operation.queryCompletionBlock = completion
        
        operation.recordFetchedBlock = { (record:CKRecord!) in
            guard let data = self.convertScholarRecord(record) else {
                print("loadScholars - Scholar data of \(record.recordID.recordName) is not complete")
                return
            }
            
            guard let scholar = Scholar(record: data) else {
                print("loadScholars - Scholar could not be created")
                return
            }
            
            recordFetched(scholar)
        }
        
        self.database.add(operation)
    }
    
    internal func convertScholarRecord(_ record: CKRecord) -> [String: Any]? {
        var testData: [String: Any] = [:]
        
        if let id = UUID.init(uuidString: record.recordID.recordName) {
            testData["id"] = id
        }else { return nil }
        
        if let creationDate = record.creationDate {
            testData["creationDate"] = creationDate
        }else { return nil }
        
        if let modifyDate = record.modificationDate {
            testData["modifyDate"] = modifyDate
        }else { return nil }
        
        if let location = record["location"] as? CLLocation {
            testData["latitude"] = location.coordinate.latitude
            testData["longitude"] = location.coordinate.longitude
        }else { return nil }
        
        if let shortBio = record["shortBio"] as? String {
            testData["shortBio"] = shortBio
        }else { return nil }
        
        if let genderStr = record["gender"] as? String,
            let gender = Gender.init(rawValue: genderStr) {
            testData["gender"] = gender
        }else { return nil }
        
        if let birthday = record["birthday"] as? Date {
            testData["birthday"] = birthday
        }else { return nil }
        
        if let email = record["email"] as? String {
            testData["email"] = email
        }else { return nil }
        
        if let firstName = record["firstName"] as? String {
            testData["firstName"] = firstName
        }else { return nil }
        
        if let lastName = record["lastName"] as? String {
            testData["lastName"] = lastName
        }else { return nil }
       
        if let socialMedia = record["socialMedia"] as? CKReference,
            let socialMediaId = UUID.init(uuidString: socialMedia.recordID.recordName) {
            testData["socialMedia"] = socialMediaId
        }else { return nil }
        
        if let wwdcYears = record["wwdcYears"] as? [CKReference],
            let wwdcYearInfos = record["wwdcYearInfos"] as? [CKReference] {
            var wwdcInfo: [WWDCYear: UUID] = [:]
            for (index, wwdcYear) in wwdcYears.enumerated() {
                if let year = WWDCYear.init(rawValue: wwdcYear.recordID.recordName),
                    let info = UUID.init(uuidString: wwdcYearInfos[index].recordID.recordName) {
                    wwdcInfo[year] = info
                }
            }
            testData["yearInfo"] = wwdcInfo
        }else { return nil }
        
        testData["profilePictureUrl"] = URL.init(string: "https://wwdcscholars.com")
        
        if let statusStr = record["status"] as? String,
            let status = Scholar.Status.init(rawValue: statusStr) {
            testData["status"] = status
        }else { return nil }
        
//        if let approvedOn = record["approvedOn"] as? Date {
            testData["approvedOn"] = record["approvedOn"] as? Date
//        }else { return nil }
        
        return testData
    }
}
