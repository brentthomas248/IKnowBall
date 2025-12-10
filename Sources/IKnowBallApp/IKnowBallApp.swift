import SwiftUI
import FeatureSettings
import IKnowBallFeature
import OSLog

@main
struct IKnowBallApp: App {
    
    private let logger = Logger(subsystem: "com.iknowball.app", category: "lifecycle")
    
    init() {
        logger.info("App initialization started")
        // TESTING: Reset XP on every app launch
        UserProfileService.shared.resetXP()
        logger.info("App initialization complete")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
        }
    }
}
