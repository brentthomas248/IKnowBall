import Foundation

public struct BallKnowledgeQuestion: Identifiable, Codable, Sendable {
    public let id: UUID
    public let stat: String
    public let teamAbbr: String
    public let playerName: String
    public let tier: Int
    public var isRevealed: Bool
    
    public init(stat: String, teamAbbr: String, playerName: String, tier: Int) {
        self.id = UUID()
        self.stat = stat
        self.teamAbbr = teamAbbr
        self.playerName = playerName
        self.tier = tier
        self.isRevealed = false
    }
    
    enum CodingKeys: String, CodingKey {
        case stat, teamAbbr, playerName, tier
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stat = try container.decode(String.self, forKey: .stat)
        self.teamAbbr = try container.decode(String.self, forKey: .teamAbbr)
        self.playerName = try container.decode(String.self, forKey: .playerName)
        self.tier = try container.decode(Int.self, forKey: .tier)
        
        // Default values for local state
        self.id = UUID()
        self.isRevealed = false
    }
}
