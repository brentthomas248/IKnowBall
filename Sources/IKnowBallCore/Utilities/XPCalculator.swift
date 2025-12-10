import Foundation

// MARK: - XP Calculator
// Calculates XP rewards based on game performance metrics

public struct XPCalculator {
    
    // MARK: - Models
    
    public struct GameMetrics {
        public let score: Int
        public let correctCount: Int
        public let totalQuestions: Int
        public let timeRemaining: TimeInterval?  // nil for untimed games
        public let isPerfect: Bool
        
        public init(
            score: Int,
            correctCount: Int,
            totalQuestions: Int,
            timeRemaining: TimeInterval? = nil,
            isPerfect: Bool = false
        ) {
            self.score = score
            self.correctCount = correctCount
            self.totalQuestions = totalQuestions
            self.timeRemaining = timeRemaining
            self.isPerfect = isPerfect
        }
    }
    
    public struct XPBreakdown {
        public let baseXP: Int
        public let scoreBonus: Int
        public let accuracyBonus: Int
        public let speedBonus: Int
        public let perfectBonus: Int
        
        public var total: Int {
            baseXP + scoreBonus + accuracyBonus + speedBonus + perfectBonus
        }
        
        public init(
            baseXP: Int,
            scoreBonus: Int,
            accuracyBonus: Int,
            speedBonus: Int,
            perfectBonus: Int
        ) {
            self.baseXP = baseXP
            self.scoreBonus = scoreBonus
            self.accuracyBonus = accuracyBonus
            self.speedBonus = speedBonus
            self.perfectBonus = perfectBonus
        }
    }
    
    // MARK: - Calculation
    
    public static func calculate(metrics: GameMetrics) -> XPBreakdown {
        // Base XP - everyone gets this
        let baseXP = 100
        
        // Score bonus - higher scores earn more XP
        let scoreBonus = metrics.score / 10
        
        // Accuracy bonus - percentage correct * 100
        let accuracy = Double(metrics.correctCount) / Double(max(1, metrics.totalQuestions))
        let accuracyBonus = Int(accuracy * 100)
        
        // Speed bonus - 1 XP per 2 seconds remaining (for timed games)
        let speedBonus: Int
        if let time = metrics.timeRemaining, time > 0 {
            speedBonus = Int(time / 2)
        } else {
            speedBonus = 0
        }
        
        // Perfect game bonus - big reward for flawless play
        let perfectBonus = metrics.isPerfect ? 200 : 0
        
        return XPBreakdown(
            baseXP: baseXP,
            scoreBonus: scoreBonus,
            accuracyBonus: accuracyBonus,
            speedBonus: speedBonus,
            perfectBonus: perfectBonus
        )
    }
}
