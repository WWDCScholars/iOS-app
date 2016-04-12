//
//  Scholar.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import Foundation

struct Scholar {
    var firstName: String
    var lastName: String
    
    var email: String
    var gender: Gender
    
    var birthday: NSDate
    var age: Int
    
    var shortBio: String
    var location: Location

    var numberOfTimesWWDCScholar: Int
    var batchWWDC: [WWDC]
    
    var iTunesURL: URL
    var websiteURL: URL
    var linkedInURL: URL
    var githubURL: URL
    var facebookURL: URL
    
    var screenshots: [URL]
    
}