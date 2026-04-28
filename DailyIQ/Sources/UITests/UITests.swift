import XCTest

class UITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--reset-notifications"]
        app.launch()
    }

    func testTabNavigation() {
        // Test Today tab
        XCTAssertTrue(app.tabBars.buttons["Today"].exists)
        app.tabBars.buttons["Today"].tap()

        // Test Calendar tab
        app.tabBars.buttons["Calendar"].tap()
        XCTAssertTrue(app.tabBars.buttons["Calendar"].exists)

        // Test Goals tab
        app.tabBars.buttons["Goals"].tap()
        XCTAssertTrue(app.tabBars.buttons["Goals"].exists)

        // Test Insights tab
        app.tabBars.buttons["Insights"].tap()
        XCTAssertTrue(app.tabBars.buttons["Insights"].exists)

        // Test Settings tab
        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(app.tabBars.buttons["Settings"].exists)
    }
}
