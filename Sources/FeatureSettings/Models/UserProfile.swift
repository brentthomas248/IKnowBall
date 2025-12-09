import Foundation

public struct UserProfile: Codable, Equatable {
    public let username: String
    public let level: Int
    public let currentXP: Double
    public let maxXP: Double
    public var avatarURL: URL? = nil

    public init(username: String, level: Int, currentXP: Double, maxXP: Double, avatarURL: URL? = nil) {
        self.username = username
        self.level = level
        self.currentXP = currentXP
        self.maxXP = maxXP
        self.avatarURL = avatarURL
    }
}
