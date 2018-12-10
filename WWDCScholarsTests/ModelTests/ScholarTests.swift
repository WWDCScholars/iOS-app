//
//  ScholarTests.swift
//  WWDCScholarsTests
//
//  Created by Matthijs Logemann on 10/12/2018.
//  Copyright © 2018 WWDCScholars. All rights reserved.
//

import XCTest
import CoreLocation
@testable import WWDCScholars

class ScholarTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConstructor() {
        let testData: [String: Any] = []
        testData["id"] = UUID.init(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        testData["creationDate"] = Date.init(timeIntervalSince1970: 1544467154)
        testData["location"] = CLLocation.init(latitude: 50.01774, longitude: 30.24939)
        testData["shortBio"] = "Test bio"
        testData["gender"] = .male
        testData["birthday"] = Date.init(timeIntervalSince1970: 1544467305)
        testData["email"] = "test@email.com"
        testData["firstName"] = "FNTest"
        testData["lastName"] = "LNTest"
        testData["socialMedia"] = UUID.init(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        testData["yearInfo"] = [.wwdc2018: UUID.init(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")]
        testData["status"]  = .pending
        testData["approvedOn"] = Date.init(timeIntervalSince1970: 1444467305)
        
        
        
        
        
        
        
        
    }
    
    
    
    func testConstructorError() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
}
