import XCTest

final class ScreenshotTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
        Thread.sleep(forTimeInterval: 2.0)  // Wait for App to fully stabilize
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    // MARK: - Screenshot Helper

    private func capture(_ name: String) {
        let path = "/tmp/\(name).png"
        let data = app.windows.firstMatch.screenshot().pngRepresentation
        try? data.write(to: URL(fileURLWithPath: path))
    }

    // MARK: - Tab Navigation Helper (uses NSPredicate + firstMatch)

    private func tapTab(identifier: String) {
        let predicate = NSPredicate(format: "identifier == %@", identifier)
        let button = app.buttons.matching(predicate).firstMatch
        if button.exists {
            button.tap()
            Thread.sleep(forTimeInterval: 1.5)  // Wait for page to render
        } else {
            print("WARNING: Could not find tab button with identifier: \(identifier)")
        }
    }

    // MARK: - iPhone 6.9" Screenshots (1320×2868) - iPhone 16 Pro Max

    func testiPhone_69_01_Today() {
        capture("iPhone_69_portrait_01_Today")
    }

    func testiPhone_69_02_Calendar() {
        tapTab(identifier: "tab_calendar")
        capture("iPhone_69_portrait_02_Calendar")
    }

    func testiPhone_69_03_AI() {
        tapTab(identifier: "tab_ai")
        capture("iPhone_69_portrait_03_AI")
    }

    func testiPhone_69_04_Goals() {
        tapTab(identifier: "tab_goals")
        capture("iPhone_69_portrait_04_Goals")
    }

    func testiPhone_69_05_Insights() {
        tapTab(identifier: "tab_insights")
        capture("iPhone_69_portrait_05_Insights")
    }

    func testiPhone_69_06_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPhone_69_portrait_06_Settings")
    }

    // MARK: - iPhone 6.5" Screenshots (1284×2778) - iPhone 14 Plus

    func testiPhone_65_01_Today() {
        capture("iPhone_65_portrait_01_Today")
    }

    func testiPhone_65_02_Calendar() {
        tapTab(identifier: "tab_calendar")
        capture("iPhone_65_portrait_02_Calendar")
    }

    func testiPhone_65_03_AI() {
        tapTab(identifier: "tab_ai")
        capture("iPhone_65_portrait_03_AI")
    }

    func testiPhone_65_04_Goals() {
        tapTab(identifier: "tab_goals")
        capture("iPhone_65_portrait_04_Goals")
    }

    func testiPhone_65_05_Insights() {
        tapTab(identifier: "tab_insights")
        capture("iPhone_65_portrait_05_Insights")
    }

    func testiPhone_65_06_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPhone_65_portrait_06_Settings")
    }

    // MARK: - iPhone 6.3" Screenshots (1206×2622) - iPhone 16 Pro

    func testiPhone_63_01_Today() {
        capture("iPhone_63_portrait_01_Today")
    }

    func testiPhone_63_02_Calendar() {
        tapTab(identifier: "tab_calendar")
        capture("iPhone_63_portrait_02_Calendar")
    }

    func testiPhone_63_03_AI() {
        tapTab(identifier: "tab_ai")
        capture("iPhone_63_portrait_03_AI")
    }

    func testiPhone_63_04_Goals() {
        tapTab(identifier: "tab_goals")
        capture("iPhone_63_portrait_04_Goals")
    }

    func testiPhone_63_05_Insights() {
        tapTab(identifier: "tab_insights")
        capture("iPhone_63_portrait_05_Insights")
    }

    func testiPhone_63_06_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPhone_63_portrait_06_Settings")
    }

    // MARK: - iPad 13" Screenshots (2048×2732) - iPad Pro 13-inch (M4)

    func testiPad_13_01_Today() {
        capture("iPad_13_portrait_01_Today")
    }

    func testiPad_13_02_Calendar() {
        tapTab(identifier: "tab_calendar")
        capture("iPad_13_portrait_02_Calendar")
    }

    func testiPad_13_03_AI() {
        tapTab(identifier: "tab_ai")
        capture("iPad_13_portrait_03_AI")
    }

    func testiPad_13_04_Goals() {
        tapTab(identifier: "tab_goals")
        capture("iPad_13_portrait_04_Goals")
    }

    func testiPad_13_05_Insights() {
        tapTab(identifier: "tab_insights")
        capture("iPad_13_portrait_05_Insights")
    }

    func testiPad_13_06_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPad_13_portrait_06_Settings")
    }

    // MARK: - iPad 11" Screenshots (1668×2388) - iPad Pro 11-inch (M4)

    func testiPad_11_01_Today() {
        capture("iPad_11_portrait_01_Today")
    }

    func testiPad_11_02_Calendar() {
        tapTab(identifier: "tab_calendar")
        capture("iPad_11_portrait_02_Calendar")
    }

    func testiPad_11_03_AI() {
        tapTab(identifier: "tab_ai")
        capture("iPad_11_portrait_03_AI")
    }

    func testiPad_11_04_Goals() {
        tapTab(identifier: "tab_goals")
        capture("iPad_11_portrait_04_Goals")
    }

    func testiPad_11_05_Insights() {
        tapTab(identifier: "tab_insights")
        capture("iPad_11_portrait_05_Insights")
    }

    func testiPad_11_06_Settings() {
        tapTab(identifier: "tab_settings")
        capture("iPad_11_portrait_06_Settings")
    }
}