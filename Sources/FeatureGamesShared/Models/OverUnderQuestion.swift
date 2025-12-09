import Foundation

public struct OverUnderQuestion: Codable, Sendable {
    public let player: String
    public let team: String
    public let statContext: String
    public let lineValue: Double
    public let actualValue: Double
    
    public init(player: String, team: String, statContext: String, lineValue: Double, actualValue: Double) {
        self.player = player
        self.team = team
        self.statContext = statContext
        self.lineValue = lineValue
        self.actualValue = actualValue
    }
}
