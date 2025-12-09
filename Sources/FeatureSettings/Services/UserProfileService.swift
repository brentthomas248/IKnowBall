import Foundation

public final class UserProfileService: ObservableObject, @unchecked Sendable {
    public static let shared = UserProfileService()
    
    @Published public private(set) var userProfile: UserProfile
    
    private let userDefaultsKey = "IKnowBall_UserProfile"
    
    private init() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.userProfile = profile
        } else {
            // Default Profile
            self.userProfile = UserProfile(
                username: "Rookie",
                level: 1,
                currentXP: 0,
                maxXP: 1000
            )
        }
    }
    
    public func addXP(_ amount: Int) {
        var newXP = userProfile.currentXP + Double(amount)
        var newLevel = userProfile.level
        var maxXP = userProfile.maxXP
        
        // Simple Leveling Logic
        while newXP >= maxXP {
            newXP -= maxXP
            newLevel += 1
            maxXP = maxXP * 1.2 // 20% harder each level
        }
        
        let newProfile = UserProfile(
            username: userProfile.username,
            level: newLevel,
            currentXP: newXP,
            maxXP: maxXP,
            avatarURL: userProfile.avatarURL
        )
        
        save(profile: newProfile)
    }
    
    public func updateUsername(_ name: String) {
        let newProfile = UserProfile(
            username: name,
            level: userProfile.level,
            currentXP: userProfile.currentXP,
            maxXP: userProfile.maxXP,
            avatarURL: userProfile.avatarURL
        )
        save(profile: newProfile)
    }
    
    private func save(profile: UserProfile) {
        self.userProfile = profile
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}
