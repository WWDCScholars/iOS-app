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
                if let array = json.array {
                    self.parseScholars(array)
                    completionHandler()
                }
            }
        }
    }
    
    func parseScholars(jsonArr: [JSON]) {
        for scholarJson in jsonArr {
            if let scholar = parseScholar(scholarJson) {
                dbManager.addScholar(scholar)
            }else {
                print("Scholar (with id \(scholarJson["_id"].string)) missing items!")
            }
        }
    }
    
    func parseScholar(json: JSON) -> Scholar? {
        if let id = json["_id"].string, let latitude = json["latitude"].double, let longitude = json["longtitude"].double, let shortBio = json["shortBio"].string, let location = json["location"].string, let gender = json["gender"].string, let birthday = json["birthday"].string,let profilePic = json["profilePic2015"].string, let email = json["email"].string, let lastName = json["lastName"].string, let firstName = json["firstName"].string, let numberOfTimesWWDCScholar = json["numberOfTimesWWDCScholar"].int, let batchWWDC = json["batchWWDC"].array {
            let newScholar = Scholar()
            newScholar.id = id
            newScholar.email = email
            newScholar.facebookURL = json["facebook"].string?.stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet())!.stringByReplacingOccurrencesOfString("%3A", withString: ":")

            newScholar.firstName = firstName
            newScholar.lastName = lastName
            newScholar.githubURL = json["github"].string?.stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet())!.stringByReplacingOccurrencesOfString("%3A", withString: ":")
            newScholar.gender = (gender == "Male") ? .Male : .Female
            newScholar.iTunesURL = json["itunes"].string?.stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet())!.stringByReplacingOccurrencesOfString("%3A", withString: ":")

            newScholar.linkedInURL = json["linkedin"].string?.stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet())!.stringByReplacingOccurrencesOfString("%3A", withString: ":")

            newScholar.numberOfTimesWWDCScholar = numberOfTimesWWDCScholar
            newScholar.shortBio = shortBio
            newScholar.websiteURL = json["website"].string?.stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet())!.stringByReplacingOccurrencesOfString("%3A", withString: ":")

            newScholar.batchWWDC = batchWWDC.map { WWDC.forRawValue($0.string!) }
            newScholar.location = Location(name: location, longitude: longitude, latitude: latitude)
            newScholar.birthday = birthday.dateFromFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ")!
            newScholar.profilePicURL = profilePic.stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet())!.stringByReplacingOccurrencesOfString("%3A", withString: ":")

            var screenshots: [URL] = []
            
            if let screenshot = json["screenshotOne"].string {
                screenshots.append(screenshot)
            }
            if let screenshot = json["screenshotTwo"].string {
                screenshots.append(screenshot)
            }
            if let screenshot = json["screenshotThree"].string {
                screenshots.append(screenshot)
            }
            if let screenshot = json["screenshotFour"].string {
                screenshots.append(screenshot)
            }
            
            newScholar.screenshots = screenshots
            
            return newScholar
        }else {
//            print (json)
            return nil
        }
    }
}