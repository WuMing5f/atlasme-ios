import SwiftUI

@main
struct AtlasMeApp: App {
    @State private var initialTab: AtlasTab?
    
    var body: some Scene {
        WindowGroup {
            if let tab = initialTab {
                AtlasRootView(initialTab: tab)
            } else {
                AtlasRootView()
            }
        }
    }
    
    init() {
        // Check for environment variable (used by simctl launch with SIMCTL_CHILD_ prefix)
        // OR command-line argument
        if let tabValue = ProcessInfo.processInfo.environment["INITIAL_TAB"] {
            initialTab = AtlasTab(rawValue: tabValue)
        } else if let tabValue = ProcessInfo.processInfo.environment["SIMCTL_CHILD_INITIAL_TAB"] {
            initialTab = AtlasTab(rawValue: tabValue)
        } else {
            // Check for launch arguments: -initialTab home|journeys|map|explore|me
            let arguments = CommandLine.arguments
            
            if let tabIndex = arguments.firstIndex(of: "-initialTab"),
               tabIndex + 1 < arguments.count {
                let tabValue = arguments[tabIndex + 1]
                initialTab = AtlasTab(rawValue: tabValue)
            }
        }
    }
}
