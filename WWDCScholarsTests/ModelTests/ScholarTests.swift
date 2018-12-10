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
    
    var testData: [String: Any] = [:]

    override func setUp() {
        testData["id"] = UUID.init(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        testData["creationDate"] = Date.init(timeIntervalSince1970: 1544467154)
        testData["latitude"] = 50.01774
        testData["longitude"] = 30.24939
        testData["shortBio"] = "Test bio"
        testData["gender"] = Gender.male
        testData["birthday"] = Date.init(timeIntervalSince1970: 1544467305)
        testData["email"] = "test@email.com"
        testData["firstName"] = "FNTest"
        testData["lastName"] = "LNTest"
        testData["profilePictureUrl"] = URL.init(string: "https://wwdcscholars.com")
        testData["socialMedia"] = UUID.init(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E55")
        testData["yearInfo"] = [WWDCYear.wwdc2018: UUID.init(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E51")]
        testData["status"]  = Scholar.Status.pending
        testData["approvedOn"] = Date.init(timeIntervalSince1970: 1444467305)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConstructor() {
        let instance = Scholar.init(record: testData)
        XCTAssertNotNil(instance, "instance != nil")
        
        XCTAssertEqual(instance?.id.uuidString, "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        XCTAssertEqual(instance?.createdAt.timeIntervalSince1970, 1544467154)
        XCTAssertEqual(instance?.latitude, 50.01774)
        XCTAssertEqual(instance?.longitude, 30.24939)
        XCTAssertEqual(instance?.shortBio, "Test bio")
        XCTAssertEqual(instance?.gender, Gender.male)
        XCTAssertEqual(instance?.birthday.timeIntervalSince1970, 1544467305)
        XCTAssertEqual(instance?.email, "test@email.com")
        XCTAssertEqual(instance?.firstName, "FNTest")
        XCTAssertEqual(instance?.lastName, "LNTest")
        XCTAssertEqual(instance?.socialMediaId.uuidString, "E621E1F8-C36C-495A-93FC-0C247A3E6E55")
        XCTAssertEqual(instance?.yearInfo.count ?? 0, 1)
        XCTAssertNotNil(instance?.yearInfo[WWDCYear.wwdc2018])
        XCTAssertEqual(instance?.yearInfo[WWDCYear.wwdc2018]?.uuidString, "E621E1F8-C36C-495A-93FC-0C247A3E6E51")
        XCTAssertEqual(instance?.status, Scholar.Status.pending)
        XCTAssertEqual(instance?.approvedOn?.timeIntervalSince1970, 1444467305)
    }
    
    func testConstructorError() {
        var testData: [String: Any] = [:]
        testData["id"] = nil

        let instance = Scholar.init(record: testData)
        XCTAssertNil(instance, "instance == nil")
    }
    
    func testFullName() {
        let instance = Scholar.init(record: testData)
        XCTAssertNotNil(instance, "instance != nil")
        
        XCTAssertEqual(instance?.fullName, "FNTest LNTest")
    }
    
    func testLocation() {
        let instance = Scholar.init(record: testData)
        XCTAssertNotNil(instance, "instance != nil")
        
        XCTAssertEqual(instance?.location.coordinate.latitude, 50.01774)
        XCTAssertEqual(instance?.location.coordinate.longitude, 30.24939)
    }
}
