//
//  ScholarTests.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import XCTest
@testable import WWDCScholars
import RealmSwift

// I added A,B,C to determine the order
class ScholarTests: XCTestCase {
    
    var dbManager: DatabaseManager!
    static var deletedScholars = false
    
    override func setUp() {
        super.setUp()
        dbManager = DatabaseManager(realm: try! Realm(configuration: Realm.Configuration(inMemoryIdentifier: "wwdcscholars-unit-test")))
        
        if !ScholarTests.deletedScholars {
            print ("Deleted scholars!")
            dbManager.deleteAllScholars()
            ScholarTests.deletedScholars = true
        }
    }
    
    func testADatabaseEmpty() {
        XCTAssertTrue(dbManager.realm.isEmpty)
    }
    
    func testBScholarModel(){
        let testScholar = Scholar()
        testScholar.id = "testScholar1"
        testScholar.firstName = "Matthijs"
        testScholar.lastName = "Logemann"
        testScholar.birthday = NSDate.date(year: 1999, month: 4, day: 27)
        testScholar.batchWWDC = [.WWDC2015]
        testScholar.email = "matthijs@logicbit.nl"
        testScholar.gender = .Male
        testScholar.numberOfTimesWWDCScholar = 1
        testScholar.shortBio = "Hi! I'm Matt. And this is a test scholar :D"
        
        dbManager.addScholar(testScholar)
        XCTAssertEqual(dbManager.scholarCount(), 1)
    }
    
    func testCScholarFromDB() {
        let scholar = dbManager.scholarForId("testScholar1")
        XCTAssertNotNil(scholar)
        
        if let testScholar = scholar {
            
            XCTAssertTrue(testScholar.id == "testScholar1")
            XCTAssertTrue(testScholar.firstName == "Matthijs")
            XCTAssertTrue(testScholar.lastName == "Logemann")
            XCTAssertTrue(testScholar.fullName == "Matthijs Logemann")
            XCTAssertTrue(testScholar.age == 17)
            XCTAssertTrue(testScholar.batchWWDC == [.WWDC2015])
            XCTAssertTrue(testScholar.email == "matthijs@logicbit.nl")
            XCTAssertTrue(testScholar.gender == .Male)
            XCTAssertTrue(testScholar.numberOfTimesWWDCScholar == 1)
            XCTAssertTrue(testScholar.shortBio == "Hi! I'm Matt. And this is a test scholar :D")
            
        }
    }
    
    func testCScholarArray() {
        let scholars = dbManager.getAllScholars()
        XCTAssertEqual(scholars.count, 1)
    }
}
