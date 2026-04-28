import XCTest

class ScreenshotTests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testTakeScreenshots() {
        // Today tab
        takeScreenshot(name: "01-Today")

        // Calendar tab
        app.tabBars.buttons["Calendar"].tap()
        takeScreenshot(name: "02-Calendar")

        // Goals tab
        app.tabBars.buttons["Goals"].tap()
        takeScreenshot(name: "03-Goals")

        // Insights tab
        app.tabBars.buttons["Insights"].tap()
        takeScreenshot(name: "04-Insights")

        // Settings tab
        app.tabBars.buttons["Settings"].tap()
        takeScreenshot(name: "05-Settings")
    }

    private func takeScreenshot(name: String) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot, name: name)
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
