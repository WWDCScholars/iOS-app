//
//  ScholarsKit.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation
import CryptoSwift

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
        newScholar.iMessage = scholarConnect["iMessage"].string

        for batchJson in scholarBatch {
            let batch = Batch()
            
            let batchString = batchJson["batchWWDC"].string ?? ""
//            print (batchString)
            
            batch.batchWWDC = WWDC.forRawValue(batchString)
            
            batch.id = "\(id)\(batch.batchWWDC.rawValue)"
            
            var screenshots: [URL] = []
            if let screenshot = workaroundServerURLEncode(batchJson["screenshotOne"].string) {
                screenshots.append(screenshot)
            }
            if let screenshot = workaroundServerURLEncode(batchJson["screenshotTwo"].string) {
                screenshots.append(screenshot)
            }
            if let screenshot = workaroundServerURLEncode(batchJson["screenshotThree"].string) {
                screenshots.append(screenshot)
            }
            if let screenshot = workaroundServerURLEncode(batchJson["screenshotFour"].string) {
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
            
        }else {
            print("parseScholar -- Missing id")
            return nil
        }
    }
    
    func updateScholarData(id: String,
                           password: String,
                           profilePic: UIImage? = nil,
                           screenshotOne: UIImage? = nil,
                           screenshotTwo: UIImage? = nil,
                           screenshotThree: UIImage? = nil,
                           screenshotFour: UIImage? = nil,
                           firstName: String? = nil,
                           lastName: String? = nil,
                           email: String? = nil,
                           birthday: NSDate? = nil,
                           location: Location? = nil,
                           videoLink: String? = nil,
                           githubLinkApp: String? = nil,
                           twitter: String? = nil,
                           facebook: String? = nil,
                           github: String? = nil,
                           linkedin: String? = nil,
                           website: String? = nil,
                           itunes: String? = nil,
                           iMessage: String? = nil,
                           shortBio: String? = nil,
                           completionHandler: ((error: ErrorType?, message: String) -> Void)? = nil
                           ) {
        
//        print ("Helo")
//        return
        upload(.POST,
               "\(self.serverUrl)/api/updateIOSMULTER/\(self.apiKey)/\(id)",
        multipartFormData: { multipartFormData in
//            multipartFormData.appendBodyPart(data: id.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name: "scholar_id")
            multipartFormData.appendBodyPart(data: password.dataUsingEncoding(NSUTF8StringEncoding)!.sha256()!.toHexString().dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!, name: "password")
            
            if let profilePic = profilePic {
                multipartFormData.appendBodyPart(data: UIImagePNGRepresentation(profilePic)!, name: "profilePic", fileName: "profilePic.png", mimeType: "image/png")
            }
            
            if let screenshotOne = screenshotOne {
                multipartFormData.appendBodyPart(data: UIImagePNGRepresentation(screenshotOne)!, name: "screenshotOne", fileName: "screenshotOne.png", mimeType: "image/png")
            }
            if let screenshotTwo = screenshotTwo {
                multipartFormData.appendBodyPart(data: UIImagePNGRepresentation(screenshotTwo)!, name: "screenshotTwo", fileName: "screenshotTwo.png", mimeType: "image/png")
            }
            if let screenshotThree = screenshotThree {
                multipartFormData.appendBodyPart(data: UIImagePNGRepresentation(screenshotThree)!, name: "screenshotThree", fileName: "screenshotThree.png", mimeType: "image/png")
            }
            if let screenshotFour = screenshotFour {
                multipartFormData.appendBodyPart(data: UIImagePNGRepresentation(screenshotFour)!, name: "screenshotFour", fileName: "screenshotFour.png", mimeType: "image/png")
            }
            
            if let firstName = firstName {
                multipartFormData.appendBodyPart(data: firstName.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"firstName")
            }
            if let lastName = lastName {
                multipartFormData.appendBodyPart(data: lastName.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"lastName")
            }
            if let birthday = birthday {
                multipartFormData.appendBodyPart(data: (birthday.stringFromFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ")).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"birthday")
            }
            if let location = location {
                multipartFormData.appendBodyPart(data: location.name.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"location")
                multipartFormData.appendBodyPart(data: "\(location.latitude)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"latitude")
                multipartFormData.appendBodyPart(data: "\(location.longitude)".dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"longtitude")
            }
            if let videoLink = videoLink {
                multipartFormData.appendBodyPart(data: videoLink.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"videoLink")
            }
            if let githubLinkApp = githubLinkApp {
                multipartFormData.appendBodyPart(data: githubLinkApp.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"githubLinkApp")
            }
            if let twitter = twitter {
                multipartFormData.appendBodyPart(data: twitter.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"twitter")
            }
            if let facebook = facebook {
                multipartFormData.appendBodyPart(data: facebook.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"facebook")
            }
            if let github = github {
                multipartFormData.appendBodyPart(data: github.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"github")
            }
            if let linkedin = linkedin {
                multipartFormData.appendBodyPart(data: linkedin.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"linkedin")
            }
            if let itunes = itunes {
                multipartFormData.appendBodyPart(data: itunes.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"itunes")
            }
            if let iMessage = iMessage {
                multipartFormData.appendBodyPart(data: iMessage.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"iMessage")
            }
            if let shortBio = shortBio {
                multipartFormData.appendBodyPart(data: shortBio.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!, name :"shortBio")
            }
            },
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .Success(let upload, _, _):
                upload.responseData { response in
                    if response.result.error != nil {
                        completionHandler?(error: response.result.error!, message: response.result.error!.localizedDescription)
                        return
                    }
                    
                    let json = JSON(data: response.result.value!)
                    if json["errorCode"].int == -1 {
                        print (json["message"].string)
                        completionHandler?(error: nil, message: json["message"].string!)
                    }else if json["errorCode"].int == -1004 {
                        completionHandler?(error: Error.error(code: -1004, failureReason: "Wrong password!"), message: json["message"].string!)
                    }
//                    else if json["errorCode"].int == -1004 {
//                        completionHandler?(error: Error.error(code: -1004, failureReason: "No scholar with that ID"), message: json["message"].string!)
//                    }
                }
                break
            case .Failure(let encodingError):
                completionHandler?(error: encodingError, message: "Error")
                break
                
            }
        })
    }
    
    private func workaroundServerURLEncode(url: URL?) -> URL? {
        return url?.stringByAddingPercentEncodingWithAllowedCharacters(.URLPathAllowedCharacterSet())!.stringByReplacingOccurrencesOfString("%3A", withString: ":")
    }
}