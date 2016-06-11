//
//  Scholar.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation
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
    
    private dynamic var genderInt: Int = 0
    /// The gender of the scholar
    var gender: Gender {
        get {
            switch genderInt {
            case 0:
                return .Unknown
            case 1:
                return .Male
            case 2:
                return .Female
            default:
                return .Unknown
            }
        }
        set {
            genderInt = newValue.rawValue
        }
    }
    
    /// The birthday of the scholar
    dynamic var birthday: NSDate = NSDate.today()
    /// The age of the scholar
    dynamic var age: Int {
        let ageComponents = NSCalendar.currentCalendar().components(.Year,
                                                                    fromDate: birthday,
                                                                    toDate: NSDate(),
                                                                    options: [])
        let age = ageComponents.year
        return age
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
    dynamic var iTunesURL: URL?
    /// URL of his/her website (may be nil)
    dynamic var websiteURL: URL?
    /// URL to his/her LinkedIn page (may be nil)
    dynamic var linkedInURL: URL?
    /// URL to his/her GitHub page (may be nil)
    dynamic var githubURL: URL?
    /// URL to his/her Facebook page (may be nil)
    dynamic var facebookURL: URL?
    /// URL of his/her website (may be nil)
    dynamic var twitterURL: URL?
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
    
    dynamic var profilePic: URL = ""
    
    //App Links
    dynamic var githubLink: URL? = nil
    dynamic var youtubeLink: URL? = nil
    dynamic var appstoreSubmissionURL: URL?

    /// Array of screenshots of their Scholar app
    private dynamic var screenshotsString: String = ""
    /// Array of screenshots
    var screenshots: [URL] {
        set {
            var strArr: [String] = []
            let arr: [URL] = newValue
            for wwdc in arr {
                strArr.append(wwdc)
            }
            screenshotsString = strArr.joinWithSeparator("|")
        }
        
        get {
            let strArr = screenshotsString.componentsSeparatedByString("|")
            var arr: [URL] = []
            for str in strArr {
                arr.append(str)
            }
            return arr.reverse()
        }
    }
    
    override class func primaryKey() -> String {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["batchWWDC", "appType", "screenshots"]
    }
}