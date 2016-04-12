//
//  Scholar.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation

struct Scholar {
     /// The first name of the scholar
    var firstName: String
     /// The last name of the scholar
    var lastName: String
    
     /// The E-Mail address of the scholar
    var email: String
     /// The gender of the scholar
    var gender: Gender
    
     /// The birthday of the scholar
    var birthday: NSDate
     /// The age of the scholar
    var age: Int
    
     /// A short description of him/herself
    var shortBio: String
    
     /// The location the scholar provided
    var location: Location

     /// Number of times the scholar has been a WWDC Scholar
    var numberOfTimesWWDCScholar: Int
     /// Array of WWDC's the scholar has been to
    var batchWWDC: [WWDC]
    
     /// The URL of his/her iTunes (developer) account
    var iTunesURL: URL
     /// URL of his/her website (may be nil)
    var websiteURL: URL?
     /// URL to his/her LinkedIn page (may be nil)
    var linkedInURL: URL?
    /// URL to his/her GitHub page (may be nil)
    var githubURL: URL
    /// URL to his/her Facebook page (may be nil)
    var facebookURL: URL
    
     /// Array of screenshots of their Scholar app
    var screenshots: [URL]
    
}