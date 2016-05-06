//
//  WWDCScholarsUITests.swift
//  WWDCScholarsUITests
//
//  Created by Matthijs Logemann on 10/04/16.
//  Copyright © 2016 WWDCScholars. All rights reserved.
//

import XCTest

class WWDCScholarsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testScholarsDetailScreen() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
//        let app = XCUIApplication()
//        app.otherElements.containingType(.Button, identifier:"wwdcScholarsTabIcon").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(3).childrenMatchingType(.CollectionView).element.tap()
//        
//        let collectionViewsQuery = app.collectionViews
//        let staticText = collectionViewsQuery.staticTexts["2016"]
//        staticText.swipeRight() //Swipe to 2015, not needed after May 9!
//        
//        /// Get cell to check for existence
//        let cell = collectionViewsQuery.cells.otherElements.containingType(.StaticText, identifier:"Matthijs").childrenMatchingType(.Image).element
//        
//        /// Wait until the cell exists, thus data got loaded
//        let exists = NSPredicate(format: "exists == 1")
//        expectationForPredicate(exists, evaluatedWithObject: cell, handler: nil)
//        waitForExpectationsWithTimeout(60, handler: nil)
//        
//        sleep(5)
//
//        cell.tap()
//
//        snapshot("2-ScholarDetail", waitForLoadingIndicator: false)
    }
    
    func testScholarsOverviewScreen() {
        
//        let exists = NSPredicate(format: "exists == 1")
//        expectationForPredicate(exists, evaluatedWithObject: firstArticle, handler: nil)
//        waitForExpectationsWithTimeout(60, handler: nil)
//        firstArticle.tap()

//        let app = XCUIApplication()
//        app.tabBars.buttons["Scholars"].tap()
//        app.collectionViews.staticTexts["2016"].swipeRight()
//        snapshot("0-ScholarsOverview", waitForLoadingIndicator: false)
    }
    
    func testCreditsScreen(){
//        
//        let app = XCUIApplication()
//        app.tabBars.buttons["Credits"].tap()
//        app.scrollViews.otherElements.tables.staticTexts["Oliver Binns (London, UK)"].swipeUp()
//        snapshot("6-Credits", waitForLoadingIndicator: false)
    }
    
    func testBlogScreen(){
//        XCUIApplication().tabBars.buttons["Blog"].tap()
//        snapshot("4-Blog", waitForLoadingIndicator: false)
    }
    
    func testChatScreen(){
//        XCUIApplication().tabBars.buttons["Chat"].tap()
//        snapshot("3-Chat", waitForLoadingIndicator: false)
    }
    
    func testLoginScreen(){
//        let app = XCUIApplication()
//        app.tabBars.buttons["Scholars"].tap()
//        app.navigationBars["Scholars"].buttons["barButtonItemIconAccountFilled"].tap()
//        snapshot("7-Login", waitForLoadingIndicator: false)
    }
    
    func testMapScreen(){
        
//        let app = XCUIApplication()
//        let mapiconButton = app.navigationBars["Scholars"].buttons["mapIcon"]
//        mapiconButton.tap()
//        
//        addUIInterruptionMonitorWithDescription("Location Dialog") { (alert) -> Bool in
//            alert.buttons["Allow"].tap()
//            return true
//        }
//        
//        app.tap() // need to interact with the app for the handler to fire
//
//        snapshot("1-Map", waitForLoadingIndicator: false)

    }
    
    func editDetailsScreen(){
        
   //     XCUIApplication().otherElements.containingType(.Button, identifier:"wwdcScholarsTabIcon").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.pressForDuration(1.1);
        
    }
    
}
