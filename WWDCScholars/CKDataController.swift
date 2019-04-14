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
    
    func scholars(for year: WWDCYear, with status: Scholar.Status?) -> [Scholar] {
        var loadedScholars: [Scholar] = []
        
        let sync = SyncBlock.init()
        let yearRef = CKRecord.Reference(recordID: CKRecord.ID.init(recordName: year.recordName), action: .none)
        //let statusPredicate = (status != nil) ? "status = '\(status!.rawValue)' AND" : ""
        let predicate = NSPredicate(format: "wwdcYears CONTAINS %@", yearRef)
        
        let query = CKQuery(recordType: "Scholar", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = ["socialMedia", "familyName", "givenName", "wwdcYears", "biography", "location", "birthday", "wwdcYearInfos", "email", "gender", "profilePictureUrl"]
        operation.qualityOfService = .userInteractive
        
        scholarFetched = { (record:CKRecord!) in
            guard let scholar = Scholar(record: record) else {
                print("loadScholars - Scholar could not be created")
                return
            }
            
            print ("Hello scholar \(scholar.id.uuidString)")

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
                operation.desiredKeys = ["socialMedia", "familyName", "givenName", "wwdcYears", "biography", "location", "birthday", "wwdcYearInfos", "email", "gender", "profilePictureUrl"]
                operation.qualityOfService = .userInteractive
                operation.recordFetchedBlock = self.scholarFetched
                operation.queryCompletionBlock = self.queryCompleted
                self.container.publicCloudDatabase.add(operation)
            } else {
                sync.complete()
            }
        }
        
        operation.queryCompletionBlock = self.queryCompleted
        operation.recordFetchedBlock = self.scholarFetched
        
        self.container.publicCloudDatabase.add(operation)
        
        sync.wait(seconds: 30)
        
        return loadedScholars
    }
    
    func scholar(for id: UUID) -> Scholar? {
        var loadedScholar: Scholar? = nil
        
        let sync = SyncBlock.init()
        
        let record = CKRecord.ID.init(recordName: id.uuidString)
        let operation = CKFetchRecordsOperation.init(recordIDs: [record])
        operation.desiredKeys = ["socialMedia", "familyName", "givenName", "wwdcYears", "biography", "location", "birthday", "wwdcYearInfos", "email", "gender", "profilePictureUrl"]
        operation.qualityOfService = .userInteractive
        
        
            operation.fetchRecordsCompletionBlock = { (records, error) in
                guard error == nil,
                    let records = records,
                let record = records[record] else {
                    fatalError(error?.localizedDescription ?? "No records")
                    return
                }
                
                guard let scholar = Scholar(record: record) else {
                    print("scholar for ID - Scholar could not be created")
                    return
                }
                
                print ("Hello scholar \(scholar.id.uuidString)")
                
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

extension Scholar {
    init?(record: CKRecord) {
        let picStr = record["profilePictureUrl"] as? String ?? "https://pbs.twimg.com/profile_images/856454273164562432/sSTBrbQ0_400x400.jpg"
        
        if let id = UUID(uuidString: record.recordID.recordName),
            let creationDate = record.creationDate,
            let modifyDate = record.modificationDate,
            let location = record["location"] as? CLLocation,
            let biography = record["biography"] as? String,
            let genderStr = record["gender"] as? String,
            let gender = Gender.init(rawValue: genderStr),
            let birthday = record["birthday"] as? Date,
            let email = record["email"] as? String,
            let givenName = record["givenName"] as? String,
            let familyName = record["familyName"] as? String,
            let socialMedia = record["socialMedia"] as? CKRecord.Reference,
            let socialMediaId = UUID.init(uuidString: socialMedia.recordID.recordName),
            let wwdcYears = record["wwdcYears"] as? [CKRecord.Reference],
            let wwdcYearInfos = record["wwdcYearInfos"] as? [CKRecord.Reference],
            //let statusStr = record["status"] as? String,
            //let status = Scholar.Status.init(rawValue: statusStr),
            let picUrl = URL.init(string: picStr) {

            var wwdcInfo: [WWDCYear: UUID] = [:]
            for (index, wwdcYear) in wwdcYears.enumerated() {
                if let year = WWDCYear.init(rawValue: wwdcYear.recordID.recordName),
                    wwdcYearInfos.count > 0,
                    let info = UUID.init(uuidString: wwdcYearInfos[index].recordID.recordName) {
                    wwdcInfo[year] = info
                }
            }

            self.init(id: id,
                         givenName: givenName,
                         familyName: familyName,
                         gender: gender,
                         birthday: birthday,
                         latitude: location.coordinate.latitude,
                         longitude: location.coordinate.longitude,
                         email: email,
                         biography: biography,
                         socialMediaId: socialMediaId,
                         wwdcYearInfos: wwdcInfo,
                         //status: status,
                         createdAt: creationDate,
                         updatedAt: modifyDate,
                         profilePictureUrl: picUrl)
        }else {
            print("Missing a parameter")
            return nil
        }
//
//        if
//            self.createdAt = creationDate
//        } else {
//            return nil
//        }
//
//        if let modifyDate = record.modificationDate {
//            self.updatedAt = modifyDate
//        } else {
//            return nil
//        }
//
//        if let location = record["location"] as? CLLocation {
//            self.latitude = location.coordinate.latitude
//            self.longitude = location.coordinate.longitude
//        } else {
//            return nil
//        }
//
//        if let shortBio = record["shortBio"] as? String {
//            self.shortBio = shortBio
//        } else {
//            return nil
//        }
//
//        if let genderStr = record["gender"] as? String,
//            let gender = Gender.init(rawValue: genderStr) {
//            self.gender = gender
//        } else {
//            return nil
//        }
//
//        if let birthday = record["birthday"] as? Date {
//            self.birthday = birthday
//        } else {
//            return nil
//        }
//
//        if let email = record["email"] as? String {
//            self.email = email
//        } else {
//            return nil
//        }
//
//        if let firstName = record["firstName"] as? String {
//            self.firstName = firstName
//        } else {
//            return nil
//        }
//
//        if let lastName = record["lastName"] as? String {
//            self.lastName = lastName
//        } else {
//            return nil
//        }
//
//        if let socialMedia = record["socialMedia"] as? CKRecord.Reference,
//            let socialMediaId = UUID.init(uuidString: socialMedia.recordID.recordName) {
//            self.socialMediaId = socialMediaId
//        } else {
//            return nil
//        }
//
//        if let wwdcYears = record["wwdcYears"] as? [CKRecord.Reference],
//            let wwdcYearInfos = record["wwdcYearInfos"] as? [CKRecord.Reference] {
//            self.yearInfo = wwdcInfo
//        } else {
//            return nil
//        }
//
//        if let statusStr = record["status"] as? String,
//            let status = Scholar.Status.init(rawValue: statusStr) {
//            self.status = status
//        } else {
//            return nil
//        }
//
//        //        if let approvedOn = record["approvedOn"] as? Date {
//        self.approvedOn = record["approvedOn"] as? Date
//
//        if let picStr = record["profilePictureUrl"] as? String,
//            let picUrl = URL.init(string: picStr) {
//            self.profilePictureUrl = picUrl
//        }
//        else {
//            self.profilePictureUrl = URL.init(string: "https://pbs.twimg.com/profile_images/856454273164562432/sSTBrbQ0_400x400.jpg")!
//        }
//        Scholar.ini
    }
}
