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
    dynamic var birthday: NSDate?
    /// The age of the scholar
    dynamic var age: Int = 0
    
    /// A short description of him/herself
    dynamic var shortBio: String = ""
    
    /// The location the scholar provided, CURRENTLY NOT SAVED!
//    dynamic var location: Location?
    
    /// Number of times the scholar has been a WWDC Scholar
    dynamic var numberOfTimesWWDCScholar: Int = 0
    /// Array of WWDC's the scholar has been to, CURRENTLY SAVED AS STRINGS
//    dynamic var batchWWDC: List = List<String>()
    
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
    
    /// Array of screenshots of their Scholar app
//    dynamic var screenshots: [URL] = []
    
    override class func primaryKey() -> String {
        return "id"
    }
}