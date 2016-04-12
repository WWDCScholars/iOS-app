//
//  ScholarTests.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import XCTest

class ScholarTests: XCTestCase {
    
    func testScholarModel(){
        let testScholar = Scholar(firstName: "Matthijs", lastName: "Logemann", email: "matthijs@logicbit.nl", gender: .Male, birthday: NSDate(), age: 16, shortBio: "Test", location: Location(longitude: 0, latitude: 0, name: "The internet"), numberOfTimesWWDCScholar: 1, batchWWDC: [.WWDC2015], iTunesURL: "", websiteURL: "", linkedInURL: "", githubURL: "", facebookURL: "", screenshots: [])
        
        print (testScholar.na)
    }
}
