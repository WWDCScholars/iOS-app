//
//  ScholarTests.swift
//  WWDCScholarsTests
//
//  Created by Matthijs Logemann on 10/12/2018.
//  Copyright © 2018 WWDCScholars. All rights reserved.
//

import CloudKit
import CoreLocation
import XCTest

@testable import WWDCScholars

class ScholarTests: XCTestCase {
    var instance: Scholar? = nil

    override func setUp() {
        instance = Scholar(id: CKRecord.ID(recordName: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F"),
                           createdAt: Date(timeIntervalSince1970: 1544467154),
                           biography: "Test bio",
                           birthday: Date(timeIntervalSince1970: 1544467305),
                           email: "test@email.com",
                           familyName: "LNTest",
                           gdprConsentAt: Date(timeIntervalSince1970: 1568798724),
                           gender: .male,
                           givenName: "FNTest",
                           loc: CLLocation(latitude: 50.01774, longitude: 30.24939),
                           profilePicture: nil,
                           scholarPrivate: nil,
                           socialMedia: nil,
                           wwdcYearInfos: nil,
                           wwdcYears: nil,
                           wwdcYearsApproved: nil)
    }

    func testConstructor() {
        XCTAssertNotNil(instance, "instance != nil")

        XCTAssertEqual(instance?.id?.recordName, "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")
        XCTAssertEqual(instance?.createdAt?.timeIntervalSince1970, 1544467154)
        XCTAssertEqual(instance?.biography, "Test bio")
        XCTAssertEqual(instance?.birthday?.timeIntervalSince1970, 1544467305)
        XCTAssertEqual(instance?.email, "test@email.com")
        XCTAssertEqual(instance?.familyName, "LNTest")
        XCTAssertEqual(instance?.gdprConsentAt, Date(timeIntervalSince1970: 1568798724))
        XCTAssertEqual(instance?.gender, Gender.male)
        XCTAssertEqual(instance?.givenName, "FNTest")
        XCTAssertEqual(instance?.location.coordinate.latitude, 50.01774)
        XCTAssertEqual(instance?.location.coordinate.longitude, 30.24939)
    }

    func testFullName() {
        XCTAssertNotNil(instance, "instance != nil")

        XCTAssertEqual(instance?.fullName, "FNTest LNTest")
    }
}
