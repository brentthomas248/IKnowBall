import SwiftUI

@Observable
final class SettingsViewModel {
    enum State {
        case idle
        case loading
        case error(String)
    }

    var state: State = .idle
    
    // User Data
    var user: UserProfile
    
    // Preferences
    var isSoundEnabled: Bool = true
    var isHapticsEnabled: Bool = true
    var isDailyReminderEnabled: Bool = false
    
    init(user: UserProfile = .mock) {
        self.user = user
    }
    
    // Placeholder for future actions
    func logout() {
        // Implement logout logic
    }
}

// Mock extension for preview/init
extension UserProfile {
    static let mock = UserProfile(
        username: "PreviewUser",
        level: 5,
        currentXP: 250,
        maxXP: 1000,
        avatarURL: nil
    )
}
