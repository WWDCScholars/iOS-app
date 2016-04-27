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
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func scholarsDetailScreen() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
//        let app = XCUIApplication()
     //   app.otherElements.containingType(.Button, identifier:"wwdcScholarsTabIcon").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.tap()
      //  app.collectionViews.cells.otherElements.containingType(.StaticText, identifier:"Sam").images["placeholder"].tap()
        
    }
    
    func scholarsScreen() {
        
        let app = XCUIApplication()
        app.tabBars.buttons["Scholars"].tap()
        app.collectionViews.staticTexts["2016"].swipeRight()
        
    }
    
    func creditsScreen(){
        
        let app = XCUIApplication()
        app.tabBars.buttons["Credits"].tap()
        app.scrollViews.otherElements.tables.staticTexts["Oliver Binns (London, UK)"].swipeUp()
        
    }
    
    func blogScreen(){
        XCUIApplication().tabBars.buttons["Blog"].tap()
        
    }
    
    func chatScreen(){
        XCUIApplication().tabBars.buttons["Chat"].tap()
        
    }
    
    func loginScreen(){
        let app = XCUIApplication()
        app.tabBars.buttons["Scholars"].tap()
        app.navigationBars["Scholars"].buttons["barButtonItemIconAccountFilled"].tap()
    }
    
    func mapScreen(){
        
        let app = XCUIApplication()
        let mapiconButton = app.navigationBars["Scholars"].buttons["mapIcon"]
        mapiconButton.tap()
        app.alerts["Allow “WWDCScholars” to access your location while you use the app?"].collectionViews.buttons["Allow"].tap()
        mapiconButton.tap()
        
    }
    
    func editDetailsScreen(){
        
   //     XCUIApplication().otherElements.containingType(.Button, identifier:"wwdcScholarsTabIcon").childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).element.pressForDuration(1.1);
        
    }
    
}
