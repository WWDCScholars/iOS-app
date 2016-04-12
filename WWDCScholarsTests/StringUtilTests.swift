//
//  StringUtilTests.swift
//  WWDCScholars
//
//  Created by Matthijs Logemann on 12/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import XCTest

class StringUtilTests: XCTestCase {

    func testGitHubLink() {
        let nonGitHubLink = "http://google.com/matthijs2704"
        XCTAssertFalse(nonGitHubLink.isValidGitHubLink(), "String isn't a GitHub link, but the validator thinks it is")
        
        let gitHubLink = "http://github.com/matthijs2704"
        XCTAssertTrue(gitHubLink.isValidGitHubLink(), "String is a GitHub link, but the validator thinks it isn't")
    }
    
    func testFacebookLink() {
        let nonFacebookLink = "http://google.com/matthijs2704"
        XCTAssertFalse(nonFacebookLink.isValidFacebookLink(), "String isn't a Facebook link, but the validator thinks it is")
        
        let facebookLink = "https://www.facebook.com/matthijs.logemann"
        XCTAssertTrue(facebookLink.isValidFacebookLink(), "String is a Facebook link, but the validator thinks it isn't")
    }
    
    func testTwitterLink() {
//        let nonGitHubLink = "http://google.com/matthijs2704"
//        XCTAssertFalse(nonGitHubLink.isValidGitHubLink(), "String isn't a GitHub link, but the validator thinks it is")
//        
//        let gitHubLink = "http://github.com/matthijs2704"
//        XCTAssertTrue(gitHubLink.isValidGitHubLink(), "String is a GitHub link, but the validator thinks it isn't")
    }
}
