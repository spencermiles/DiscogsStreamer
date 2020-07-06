//
//  DiscogsStreamerUITests.swift
//  DiscogsStreamerUITests
//
//  Created by Spencer on 7/4/20.
//  Copyright © 2020 Spencer Miles. All rights reserved.
//

import XCTest

class DiscogsStreamerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        // TODO: Setup Peasy for mocking http responses
        XCTAssertTrue(app.navigationBars.staticTexts["Releases"].exists)
        XCTAssertTrue(app.tables.staticTexts["Four Tet - Sixteen Oceans"].exists)
        XCTAssertTrue(app.tables.staticTexts["Four Tet - Sixteen Oceans"].isHittable)

//        XCUIApplication().tables/*@START_MENU_TOKEN@*/.staticTexts["Robert Owens - Visions"]/*[[".cells.staticTexts[\"Robert Owens - Visions\"]",".staticTexts[\"Robert Owens - Visions\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
//        XCTAssertTrue(app.tables.staticTexts["Kroma - Sexy Films"].exists)
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}
