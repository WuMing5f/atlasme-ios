import XCTest

final class AtlasMeUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testSwitchToJourneysTab() throws {
        app.launch()
        
        // Wait for the app to launch
        let tabBar = app.tabBars["MainTabBar"]
        XCTAssertTrue(tabBar.waitForExistence(timeout: 5), "Tab bar should exist")
        
        // Tap on Journeys tab using accessibility identifier
        let journeysTab = app.buttons["tab_journeys"]
        XCTAssertTrue(journeysTab.waitForExistence(timeout: 5), "Journeys tab should exist")
        journeysTab.tap()
        
        // Take a screenshot
        let screenshot = app.windows.firstMatch.screenshot()
        XCTAttachment(screenshot: screenshot, quality: .medium)
    }
    
    func testSwitchToMapTab() throws {
        app.launch()
        
        let mapTab = app.buttons["tab_map"]
        XCTAssertTrue(mapTab.waitForExistence(timeout: 5), "Map tab should exist")
        mapTab.tap()
        
        // Take a screenshot
        let screenshot = app.windows.firstMatch.screenshot()
        XCTAttachment(screenshot: screenshot, quality: .medium)
    }
    
    func testSwitchToExploreTab() throws {
        app.launch()
        
        let exploreTab = app.buttons["tab_explore"]
        XCTAssertTrue(exploreTab.waitForExistence(timeout: 5), "Explore tab should exist")
        exploreTab.tap()
        
        // Take a screenshot
        let screenshot = app.windows.firstMatch.screenshot()
        XCTAttachment(screenshot: screenshot, quality: .medium)
    }
    
    func testSwitchToProfileTab() throws {
        app.launch()
        
        let profileTab = app.buttons["tab_me"]
        XCTAssertTrue(profileTab.waitForExistence(timeout: 5), "Profile tab should exist")
        profileTab.tap()
        
        // Take a screenshot
        let screenshot = app.windows.firstMatch.screenshot()
        XCTAttachment(screenshot: screenshot, quality: .medium)
    }
    
    func testLaunchWithInitialTab() throws {
        // Test launching with initial tab via command line argument
        // The app should support launching with a specific tab
        let args = ["-initialTab", "journeys"]
        app.launchArguments = args
        app.launch()
        
        // Wait for app to settle
        sleep(2)
        
        // Take a screenshot
        let screenshot = app.windows.firstMatch.screenshot()
        XCTAttachment(screenshot: screenshot, quality: .medium)
    }
}
