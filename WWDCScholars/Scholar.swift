//
//  Scholar.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Scholar: Object {
    /// The ID of the scholar
    dynamic var id: String = ""
    
    /// The first name of the scholar
    dynamic var firstName: String = ""
    /// The last name of the scholar
    dynamic var lastName: String = ""
    
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    var initials: String {
        return "\(firstName.characters.first!)\(lastName.characters.first!)"
    }
    
    /// The E-Mail address of the scholar
    dynamic var email: String = ""
    
    dynamic var genderInt: Int = 0
    /// The gender of the scholar
    var gender: Gender {
        get {
            switch genderInt {
            case 0:
                return .unknown
            case 1:
                return .male
            case 2:
                return .female
            default:
                return .unknown
            }
        }
        set {
            genderInt = newValue.rawValue
        }
    }
    
    /// The birthday of the scholar
    dynamic var birthday: Date = Date.today()
    /// The age of the scholar
    dynamic var age: Int {
        let ageComponents = (Calendar.current as NSCalendar).components(.year,
                                                                    from: birthday,
                                                                    to: Date(),
                                                                    options: [])
        let age = ageComponents.year
        return age!
    }
    
    /// A short description of him/herself
    dynamic var shortBio: String = ""
    
    /// Location details for easier saving
    private dynamic var latitude: Double = 0
    private dynamic var longitude: Double = 0
    private dynamic var locationString: String = ""
    /// The location the scholar provided
    var location: Location {
        get {
            return Location(name: locationString, longitude: longitude, latitude: latitude)
        }
        
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
            locationString = newValue.name
        }
    }
    
    /// The URL of his/her iTunes (developer) account
    dynamic var iTunesURL: URLString?
    /// URL of his/her website (may be nil)
    dynamic var websiteURL: URLString?
    /// URL to his/her LinkedIn page (may be nil)
    dynamic var linkedInURL: URLString?
    /// URL to his/her GitHub page (may be nil)
    dynamic var githubURL: URLString?
    /// URL to his/her Facebook page (may be nil)
    dynamic var facebookURL: URLString?
    /// URL of his/her website (may be nil)
    dynamic var twitterURL: URLString?
    dynamic var iMessage: String?

    var batches = List<Batch>()
//    var wwdcBatchesStr: String {
//        var string = ""
//        
//        _ = batches.map({ batch in
//            string += batch.batchWWDCStr
//        })
//        
//        return string
//    }
    
    var latestBatch: Batch {
        var latestBatch: Batch? = nil
        
        for batch in batches {
            if latestBatch == nil {
                latestBatch = batch
                continue
            }
            
            guard latestBatch != nil else {
                abort() //todo
            }
            
            if batch.batchWWDC.intValue > latestBatch!.batchWWDC.intValue {
                latestBatch = batch
            }
        }
        
        return latestBatch!
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["batchWWDC", "location", "age", "latestBatch"]
    }
}

class Batch: Object {
    dynamic var id = ""
    
    private dynamic var batchWWDCStr: String = ""
    var batchWWDC: WWDC {
        get {
            return WWDC.forRawValue(batchWWDCStr)
        }
        set {
            batchWWDCStr = newValue.toRawValue()
        }
    }
    
    private dynamic var appTypeStr: String = "Offline"
    var appType: AppType {
        get {
            switch appTypeStr {
            case "Offline":
                return .Offline
            case "AppStore":
                return .AppStore
            case "Both":
                return .Both
            default:
                return .Offline
            }
        }
        set {
            appTypeStr = newValue.rawValue
        }
    }
    
    dynamic var profilePic: URLString = ""
    
    //App Links
    dynamic var githubLink: URLString? = nil
    dynamic var youtubeLink: URLString? = nil
    dynamic var appstoreSubmissionURL: URLString?

    /// Array of screenshots of their Scholar app
    private dynamic var screenshotsString: String = ""
    /// Array of screenshots
    var screenshots: [URLString] {
        set {
            var strArr: [String] = []
            let arr: [URLString] = newValue
            for wwdc in arr {
                strArr.append(wwdc)
            }
            screenshotsString = strArr.joined(separator: "|")
        }
        
        get {
            let strArr = screenshotsString.components(separatedBy: "|")
            var arr: [URLString] = []
            for str in strArr {
                arr.append(str)
            }
            return arr.reversed()
        }
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["batchWWDC", "appType", "screenshots"]
    }
}
