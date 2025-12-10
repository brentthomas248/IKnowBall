import SwiftUI
import FeatureSettings
import IKnowBallFeature

@main
struct IKnowBallApp: App {
    
    init() {
        print("🚀 APP INIT CALLED")
        // TESTING: Reset XP on every app launch
        UserProfileService.shared.resetXP()
        print("🚀 APP INIT COMPLETE")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
