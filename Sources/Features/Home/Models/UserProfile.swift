import Foundation

struct UserProfile: Codable, Equatable {
    let username: String
    let level: Int
    let currentXP: Double
    let maxXP: Double
}
