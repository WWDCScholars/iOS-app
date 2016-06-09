//
//  ScholarsKit.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation

class ScholarsKit: ApiBase {
    
    /// Shared Instance of the ScholarAPI
    static let sharedInstance = ScholarsKit()
    
    let dbManager = DatabaseManager.sharedInstance
    
    private override init() {
    }
    
    /**
     Loads scholars from the online database
     */
    func loadScholars(completionHandler: () -> Void) {
        request(.GET, "\(self.serverUrl)/api/scholars/\(self.apiKey)")
            .responseString() { response in
                if let data = response.result.value {
                    //                print (data)
                    let json = JSON.parse(data)
                    //                print("JSON: \(json)")
                    print ("loadScholars -- Loading scholars")
                    if let array = json.array {
                        self.parseScholars(array)
                        completionHandler()
                    }
                }
        }
    }
    
    func hasScholars() -> Bool {
        return dbManager.scholarCount() > 0
    }
    
    func parseScholars(jsonArr: [JSON]) {
        var scholars: [Scholar] = []
        for scholarJson in jsonArr {
            if let scholar = parseScholar(scholarJson) {
                scholars.append(scholar)
            }else {
                print("Scholar (with id \(scholarJson["_id"].string)) missing items!")
            }
        }
        dbManager.addScholars(scholars)
    }
    
    func parseScholar(json: JSON) -> Scholar? {
        let scholarInfo = json["scholarsInfo"]
        let scholarConnect = json["scholarConnect"]
        let scholarBatchMaybe = json["batch"].array
        
        guard (scholarBatchMaybe != nil) else {
            return nil
        }
        
        let scholarBatch = scholarBatchMaybe!

        let newScholar = Scholar()

        if let id = scholarInfo["_id"].string {
            newScholar.id = id
        }else {
            print("parseScholar -- Missing id")
            return nil
        }
        
        if let gender = scholarInfo["gender"].string {
            newScholar.gender = (gender == "Male") ? .Male : .Female
        }else {
            print("parseScholar -- \(newScholar.id) -- Missing gender")
            return nil
        }
        
        if let firstName = scholarInfo["firstName"].string {
            newScholar.firstName = firstName
        }else {
            print("parseScholar -- \(newScholar.id) -- Missing firstName")
            return nil
        }
        
        if let lastName = scholarInfo["lastName"].string {
            newScholar.lastName = lastName
        }else {
            print("parseScholar -- \(newScholar.id) -- Missing lastName")
            return nil
        }
        
        if let location = scholarInfo["location"].string, let longitude = scholarInfo["longtitude"].double, let latitude = scholarInfo["latitude"].double{
            newScholar.location = Location(name: location, longitude: longitude, latitude: latitude)
        }else {
            print("parseScholar -- \(newScholar.id) -- Missing location")
            return nil
        }
        
        if let email = scholarInfo["email"].string {
            newScholar.email = email
        }else {
            print("parseScholar -- \(newScholar.id) -- Missing email")
            return nil
        }
        
        if let birthday = scholarInfo["birthday"].string {
            newScholar.birthday = birthday.dateFromFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ")!
        }else {
            print("parseScholar -- \(newScholar.id) -- Missing birthday")
            return nil
        }
        
        if let shortBio = scholarInfo["shortBio"].string {
            newScholar.shortBio = shortBio
        }else {
            print("parseScholar -- \(newScholar.id) -- Missing shortBio")
            return nil
        }
        
        newScholar.iTunesURL = workaroundServerURLEncode(scholarConnect["itunes"].string)
        newScholar.linkedInURL = workaroundServerURLEncode(scholarConnect["linkedin"].string)
        newScholar.websiteURL = workaroundServerURLEncode(scholarConnect["website"].string)
        newScholar.facebookURL = workaroundServerURLEncode(scholarConnect["facebook"].string)
        newScholar.githubURL = workaroundServerURLEncode(scholarConnect["github"].string)
        newScholar.twitterURL = workaroundServerURLEncode(scholarConnect["twitter"].string)
        newScholar.iMessageEmail = workaroundServerURLEncode(scholarConnect["twitter"].string)

        for batchJson in scholarBatch {
            let batch = Batch()
            
            batch.batchWWDC = WWDC.forRawValue(batchJson["batchWWDC"].string ?? "")
            
            batch.id = "\(newScholar.id)\(batch.batchWWDC.rawValue)"
            
            var screenshots: [URL] = []
            if let screenshot = batchJson["screenshotOne"].string {
                screenshots.append(screenshot)
            }
            if let screenshot = batchJson["screenshotTwo"].string {
                screenshots.append(screenshot)
            }
            if let screenshot = batchJson["screenshotThree"].string {
                screenshots.append(screenshot)
            }
            if let screenshot = batchJson["screenshotFour"].string {
                screenshots.append(screenshot)
            }
            batch.screenshots = screenshots
            
            batch.appType = AppType.forRawValue(batchJson["appType"].string)
            batch.youtubeLink = batchJson["youtubeLink"].string
            batch.githubLink = batchJson["githubLink"].string
            batch.appstoreSubmissionURL = batchJson["appStoreSubmissionLink"].string

            if let profilePic = batchJson["profilePic"].string {
                batch.profilePic = self.workaroundServerURLEncode(profilePic)!
            }else {
                print("parseBatch -- \(newScholar.id) -- Missing profilePic")
//                continue
            }
            
            DatabaseManager.sharedInstance.addRealmObject(batch, update: true)
            newScholar.batches.append(batch)
        }
        
        if (newScholar.batches.isEmpty) {
            print ("parseScholar -- \(newScholar.id) -- No batches!")
            return nil
        }

        return newScholar
    }
    
    private func workaroundServerURLEncode(url: URL?) -> URL? {
        return url?.stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet())!.stringByReplacingOccurrencesOfString("%3A", withString: ":")
    }
}