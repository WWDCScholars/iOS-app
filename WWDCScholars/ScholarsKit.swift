//
//  ScholarsKit.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation
import CryptoSwift
import Alamofire
import AlamofireImage
import SwiftyJSON

class ScholarsKit: ApiBase {
    
    /// Shared Instance of the ScholarAPI
    static let sharedInstance = ScholarsKit()
    
    let dbManager = DatabaseManager.sharedInstance
    
    fileprivate override init() {
    }
    
    /**
     Loads scholars from the online database
     */
    func loadScholars(_ completionHandler: @escaping () -> Void) {
        Alamofire.request("\(self.serverUrl)/api/scholars/\(self.apiKey)", method: .get)
            .validate()
            .responseSwiftyJSON { response in
                if let json = response.result.value {
                    //                print (data)
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
    
    func parseScholars(_ jsonArr: [JSON]) {
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
    
    func parseScholar(_ json: JSON) -> Scholar? {
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
            newScholar.gender = (gender == "Male") ? .male : .female
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
            
            newScholar.birthday = birthday.date(inFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")!
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
            
            var screenshots: [String] = []
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
    
    func updateScholarData(_ id: String,
                           password: String,
                           profilePic: UIImage? = nil,
                           screenshotOne: UIImage? = nil,
                           screenshotTwo: UIImage? = nil,
                           screenshotThree: UIImage? = nil,
                           screenshotFour: UIImage? = nil,
                           firstName: String? = nil,
                           lastName: String? = nil,
                           email: String? = nil,
                           birthday: Date? = nil,
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
                           completionHandler: ((_ error: NSError?, _ message: String) -> Void)? = nil
                           ) {
        
 
        Alamofire.upload(
            
            
            
        multipartFormData: { multipartFormData in
            
            
            multipartFormData.append(password.data(using: String.Encoding.utf8)!.sha256().toHexString().data(using: String.Encoding.utf8, allowLossyConversion: true)!, withName: "password")
            
            if let profilePic = profilePic {
                multipartFormData.append(UIImagePNGRepresentation(profilePic)!, withName: "profilePic", fileName: "profilePic.png", mimeType: "image/png")
            }
            
            if let screenshotOne = screenshotOne {
                multipartFormData.append(UIImagePNGRepresentation(screenshotOne)!, withName: "screenshotOne", fileName: "screenshotOne.png", mimeType: "image/png")
            }
            if let screenshotTwo = screenshotTwo {
                multipartFormData.append(UIImagePNGRepresentation(screenshotTwo)!, withName: "screenshotTwo", fileName: "screenshotTwo.png", mimeType: "image/png")
            }
            if let screenshotThree = screenshotThree {
                multipartFormData.append(UIImagePNGRepresentation(screenshotThree)!, withName: "screenshotThree", fileName: "screenshotThree.png", mimeType: "image/png")
            }
            if let screenshotFour = screenshotFour {
                multipartFormData.append(UIImagePNGRepresentation(screenshotFour)!, withName: "screenshotFour", fileName: "screenshotFour.png", mimeType: "image/png")
            }
            if let firstName = firstName {
                multipartFormData.append(firstName.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"firstName")
            }
            if let lastName = lastName {
                multipartFormData.append(lastName.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"lastName")
            }
            if let birthday = birthday {
                
                
                // SWIFT 3 // NEEEDS CHECKS
                
                let dateString = birthday.string(inDateStyle: .medium, andTimeStyle: .medium)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                
            
                multipartFormData.append(dateString.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "birthday")
   
              // ORIGINAL  multipartFormData.append((birthday.stringFromFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ")).data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"birthday")
            }
            if let location = location {
                multipartFormData.append(location.name.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"location")
                multipartFormData.append("\(location.latitude)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"latitude")
                multipartFormData.append("\(location.longitude)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"longtitude")
            }
            if let videoLink = videoLink {
                multipartFormData.append(videoLink.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"videoLink")
            }
            if let githubLinkApp = githubLinkApp {
                multipartFormData.append(githubLinkApp.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"githubLinkApp")
            }
            if let twitter = twitter {
                multipartFormData.append(twitter.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"twitter")
            }
            if let facebook = facebook {
                multipartFormData.append(facebook.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"facebook")
            }
            if let github = github {
                multipartFormData.append(github.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"github")
            }
            if let linkedin = linkedin {
                multipartFormData.append(linkedin.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"linkedin")
            }
            if let itunes = itunes {
                multipartFormData.append(itunes.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"itunes")
            }
            if let website = website {
                multipartFormData.append(website.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"website")
            }
            if let iMessage = iMessage {
                multipartFormData.append(iMessage.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"iMessage")
            }
            if let shortBio = shortBio {
                multipartFormData.append(shortBio.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName :"shortBio")
            }
        },to: "\(self.serverUrl)/api/updateIOSMULTER/\(self.apiKey)/\(id)", method: .post,
        encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseData { response in
                    if response.result.error != nil {
                        completionHandler?(response.result.error! as NSError?, response.result.error!.localizedDescription)
                        return
                    }
                    
                    let json = JSON(data: response.result.value!)
                    if json["errorCode"].int == -1 {
                        print("Retreiving Sucess code")
                        print (json["message"].string!)

                    
                        
                        
                        completionHandler?(nil, json["message"].string!)
                    }else if json["errorCode"].int == -1004 {
                        
                        
                       // HERE UPDATE completionHandler?(error: Error.error(code: -1004, failureReason: "Wrong password!"), message: json["message"].string!)
                    }
//                    else if json["errorCode"].int == -1004 {
//                        completionHandler?(error: Error.error(code: -1004, failureReason: "No scholar with that ID"), message: json["message"].string!)
//                    }
                }
                break
            case .failure(let encodingError):
                completionHandler?(encodingError as NSError, "Error")
                break
                
            }
        })
    }
    
    fileprivate func workaroundServerURLEncode(_ url: String?) -> String? {
        return url?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!.replacingOccurrences(of: "%3A", with: ":")
    }
}
