//
//  CloudKitManager+Scholar.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 29/05/2017.
//  Copyright © 2017 WWDCScholars. All rights reserved.
//

import Foundation
import CloudKit
import Alamofire

internal typealias ScholarFetched = ((Scholar) -> Void)

internal extension CloudKitManager {
    
    // MARK: - Internal Functions
    
//    internal func loadScholars(`for` batch: WWDCYear, with status: Scholar.Status, recordFetched: @escaping ScholarFetched, completion: QueryCompletion) {
//        let recordName = batch.recordName
//        let yearRef = CKRecord.Reference(recordID: CKRecord.ID.init(recordName: recordName), action: .none)
//        let predicate = NSPredicate(format: "status = '\(status.rawValue)' AND wwdcYears CONTAINS %@", yearRef)
//        let query = CKQuery(recordType: "Scholar", predicate: predicate)
//        let operation = CKQueryOperation(query: query)
////        operation.desiredKeys = ["gender", "location", "firstName", "status", "wwdcYearInfos", "shortBio", "birthday", "email", "lastName", "socialMedia", "wwdcYears"]
//        operation.desiredKeys = ["socialMedia", "lastName", "firstName", "wwdcYears", "shortBio", "approvedOn", "location", "birthday", "wwdcYearInfos", "email", "gender", "status", "profilePictureUrl"]
////        operation.resultsLimit = 1
//        operation.qualityOfService = .userInteractive
//
//        operation.queryCompletionBlock = completion
//
//        operation.recordFetchedBlock = { (record:CKRecord!) in
//            self.convertScholarRecord(record) { data in
//                guard let data = data else {
//                    print("loadScholars - Scholar data of \(record.recordID.recordName) is not complete")
//                    return
//                }
//
//                guard let scholar = Scholar(record: data) else {
//                    print("loadScholars - Scholar could not be created")
//                    return
//                }
//
//                DispatchQueue.main.async {
//                    recordFetched(scholar)
//                }
////                recordFetched(scholar)
//            }
//        }
//
//        self.database.add(operation)
//    }
    
    internal func convertScholarRecord(_ record: CKRecord, completion: @escaping ([String: Any]?) -> ()) {
        var testData: [String: Any] = [:]
        print(record.allKeys())
        if let id = UUID.init(uuidString: record.recordID.recordName) {
            testData["id"] = id
        }else {
            return completion(nil)
        }
        
        if let creationDate = record.creationDate {
            testData["creationDate"] = creationDate
        } else {
            return completion(nil)
        }
        
        if let modifyDate = record.modificationDate {
            testData["modifyDate"] = modifyDate
        } else {
            return completion(nil)
        }
        
        if let location = record["location"] as? CLLocation {
            testData["latitude"] = location.coordinate.latitude
            testData["longitude"] = location.coordinate.longitude
        } else {
            return completion(nil)
        }
        
        if let shortBio = record["shortBio"] as? String {
            testData["shortBio"] = shortBio
        } else {
            return completion(nil)
        }
        
        if let genderStr = record["gender"] as? String,
            let gender = Gender.init(rawValue: genderStr) {
            testData["gender"] = gender
        } else {
            return completion(nil)
        }
        
        if let birthday = record["birthday"] as? Date {
            testData["birthday"] = birthday
        } else {
            return completion(nil)
        }
        
        if let email = record["email"] as? String {
            testData["email"] = email
        } else {
            return completion(nil)
        }
        
        if let firstName = record["firstName"] as? String {
            testData["firstName"] = firstName
        } else {
            return completion(nil)
        }
        
        if let lastName = record["lastName"] as? String {
            testData["lastName"] = lastName
        } else {
            return completion(nil)
        }
        
        if let socialMedia = record["socialMedia"] as? CKRecord.Reference,
            let socialMediaId = UUID.init(uuidString: socialMedia.recordID.recordName) {
            testData["socialMedia"] = socialMediaId
        } else {
            return completion(nil)
        }
        
        if let wwdcYears = record["wwdcYears"] as? [CKRecord.Reference],
            let wwdcYearInfos = record["wwdcYearInfos"] as? [CKRecord.Reference] {
            var wwdcInfo: [WWDCYear: UUID] = [:]
            for (index, wwdcYear) in wwdcYears.enumerated() {
                if let year = WWDCYear.init(rawValue: wwdcYear.recordID.recordName),
                    wwdcYearInfos.count > 0,
                    let info = UUID.init(uuidString: wwdcYearInfos[index].recordID.recordName) {
                    wwdcInfo[year] = info
                }
            }
            testData["yearInfo"] = wwdcInfo
        } else {
            return completion(nil)
        }
        
        //        testData["profilePictureUrl"] = (record["profilePicture"] as? CKAsset)?.fileURL ?? URL.init(string: "https://wwdcscholars.com")
       
        
        if let statusStr = record["status"] as? String,
            let status = Scholar.Status.init(rawValue: statusStr) {
            testData["status"] = status
        } else {
            return completion(nil)
        }
        
        //        if let approvedOn = record["approvedOn"] as? Date {
        testData["approvedOn"] = record["approvedOn"] as? Date
        
        if let picStr = record["profilePictureUrl"] as? String,
            let picUrl = URL.init(string: picStr) {
            testData["profilePictureUrl"] = picUrl
        }
        else {
            testData["profilePictureUrl"] = URL.init(string: "https://pbs.twimg.com/profile_images/856454273164562432/sSTBrbQ0_400x400.jpg")!
        }
        
        
        completion(testData)

//        testRecordRequest(scholarId: id).responseJSON(completionHandler: { (a) in
//            if let data = a.data ,
//                let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
//                let records = json["records"] as! [[String : Any]]
//                if records.count == 1 {
//                    if let fields = records[0]["fields"] as? [String: Any],
//                        let asset = fields["profilePicture"] as? [String: Any],
//                        let value = asset["value"] as? [String: Any],
//                        let downloadUrl = value["downloadURL"] as? String {
//                        let fileName = id.uuidString + ".jpg"
//                        let imageURLString = downloadUrl.replacingOccurrences(of: "${f}", with: fileName)
//
//                        testData["profilePictureUrl"] = URL.init(string: imageURLString)
//                        //                    print(imageURLString)
//
//                        return //                    } else {
//                        print("No Profile Pic")
//                        return completion(nil)
//                    }
//                }
//            }
//            //            print(a)
//        })
//        completion(testData)
//                } else {
//            return completion(nil)
//        }
        
    }
}
