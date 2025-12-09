import Foundation

public struct BallKnowledgeQuestion: Codable, Sendable {
    public let stat: String
    public let teamAbbr: String
    public let playerName: String
    public let tier: Int
    
    public init(stat: String, teamAbbr: String, playerName: String, tier: Int) {
        self.stat = stat
        self.teamAbbr = teamAbbr
        self.playerName = playerName
        self.tier = tier
    }
}
