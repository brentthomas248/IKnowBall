import SwiftUI
import FeatureSettings
import IKnowBallCore

@Observable
final class ScoreSummaryViewModel {
    // MARK: - State

    enum State {
        case idle
        case loading
        case content
        case error(String)
    }

    var state: State = .idle

    // MARK: - Properties

    var score: Int
    var correctCount: Int
    var missedCount: Int
    var gameDuration: TimeInterval
    
    // XP specific properties
    var currentXp: Int
    var xpGained: Int
    var xpBreakdown: XPCalculator.XPBreakdown
    var xpRequiredForNextLevel: Int
    
    // Dependency
    private let profileService: UserProfileServiceProtocol
    
    // MARK: - Integration Placeholders
    // These closures would be injected by a coordinator or parent view
    var onReviewAnswers: (() -> Void)?
    var onReplayLevel: (() -> Void)?
    var onGoHome: (() -> Void)?

    // MARK: - Computed Properties

    var scoreFormatted: String {
        "\(score) Points"
    }
    
    var accuracy: Double {
        let total = correctCount + missedCount
        guard total > 0 else { return 0.0 }
        return Double(correctCount) / Double(total)
    }
    
    var accuracyFormatted: String {
        let percentage = Int(accuracy * 100)
        return "\(percentage)%"
    }
    
    var xpProgress: Double {
        guard xpRequiredForNextLevel > 0 else { return 0.0 }
        return Double(currentXp) / Double(xpRequiredForNextLevel)
    }

    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    var errorMessage: String {
        if case .error(let message) = state { return message }
        return ""
    }
    
    // XP Breakdown for display
    var xpBreakdownItems: [(String, Int)] {
        var items: [(String, Int)] = []
        
        items.append(("Base Score", xpBreakdown.baseXP))
        
        if xpBreakdown.scoreBonus > 0 {
            items.append(("Performance", xpBreakdown.scoreBonus))
        }
        
        if xpBreakdown.accuracyBonus > 0 {
            let total = correctCount + missedCount
            let accuracy = total > 0 ? Int(Double(correctCount) / Double(total) * 100) : 0
            items.append(("Accuracy (\(accuracy)%)", xpBreakdown.accuracyBonus))
        }
        
        if xpBreakdown.speedBonus > 0 {
            items.append(("Speed Bonus", xpBreakdown.speedBonus))
        }
        
        if xpBreakdown.perfectBonus > 0 {
            items.append(("Perfect Game", xpBreakdown.perfectBonus))
        }
        
        return items
    }

    // MARK: - Initialization

    init(
        score: Int = 1200,
        correctCount: Int = 12,
        missedCount: Int = 3,
        gameDuration: TimeInterval = 60,
        metrics: XPCalculator.GameMetrics? = nil,
        shouldAwardXP: Bool = true,  // NEW: Only award XP if true
        profileService: UserProfileServiceProtocol = UserProfileService.shared
    ) {
        // Calculate XP breakdown FIRST (before any self. assignments)
        let breakdown: XPCalculator.XPBreakdown
        if let metrics = metrics {
            breakdown = XPCalculator.calculate(metrics: metrics)
        } else {
            // Fallback to default metrics if none provided
            let defaultMetrics = XPCalculator.GameMetrics(
                score: score,
                correctCount: correctCount,
                totalQuestions: correctCount + missedCount,
                timeRemaining: nil,
                isPerfect: missedCount == 0
            )
            breakdown = XPCalculator.calculate(metrics: defaultMetrics)
        }
        
        // Get profile info BEFORE initializing
        let profile = profileService.userProfile
        
        // Now initialize ALL stored properties
        self.score = score
        self.correctCount = correctCount
        self.missedCount = missedCount
        self.gameDuration = gameDuration
        self.profileService = profileService
        self.xpBreakdown = breakdown
        self.xpGained = breakdown.total
        self.currentXp = Int(profile.currentXP)
        self.xpRequiredForNextLevel = Int(profile.maxXP)
        self.state = .content
        
        // Award XP ONLY if shouldAwardXP is true (prevents preview/navigation from awarding XP)
        if shouldAwardXP {
            profileService.addXP(breakdown.total)
            
            // Update current values after awarding XP
            let updatedProfile = profileService.userProfile
            self.currentXp = Int(updatedProfile.currentXP)
            self.xpRequiredForNextLevel = Int(updatedProfile.maxXP)
        }
    }

    // MARK: - Methods

    func reviewAnswers() {
        onReviewAnswers?()
    }
    
    func replayLevel() {
        onReplayLevel?()
    }
    
    func goHome() {
        onGoHome?()
    }
}
