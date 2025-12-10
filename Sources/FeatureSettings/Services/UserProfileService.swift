import Foundation

public final class UserProfileService: ObservableObject, UserProfileServiceProtocol, @unchecked Sendable {
    public static let shared = UserProfileService()
    
    @Published public private(set) var userProfile: UserProfile
    
    // Level-up callback
    public var onLevelUp: ((Int) -> Void)?
    
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
        var didLevelUp = false
        
        // Simple Leveling Logic
        while newXP >= maxXP {
            newXP -= maxXP
            newLevel += 1
            maxXP = maxXP * 1.2 // 20% harder each level
            didLevelUp = true
        }
        
        let newProfile = UserProfile(
            username: userProfile.username,
            level: newLevel,
            currentXP: newXP,
            maxXP: maxXP,
            avatarURL: userProfile.avatarURL
        )
        
        save(profile: newProfile)
        
        // Trigger level-up callback if leveled up
        if didLevelUp {
            onLevelUp?(newLevel)
        }
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
    
    // MARK: - Testing
    
    /// Reset XP to zero for testing level-up animations
    public func resetXP() {
        print("🔴 RESETTING XP TO ZERO - Current Level: \(userProfile.level)")
        
        // Force clear UserDefaults
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        
        // Create fresh profile
        let newProfile = UserProfile(
            username: userProfile.username,
            level: 1,
            currentXP: 0,
            maxXP: 1000,
            avatarURL: userProfile.avatarURL
        )
        
        save(profile: newProfile)
        print("✅ XP RESET COMPLETE - New Level: \(userProfile.level), XP: \(userProfile.currentXP)")
    }
    
    private func save(profile: UserProfile) {
        self.userProfile = profile
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
}
