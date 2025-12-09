import SwiftUI
import FeatureSettings

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
    var xpRequiredForNextLevel: Int
    
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

    // MARK: - Initialization

    init(
        score: Int = 1200,
        correctCount: Int = 12,
        missedCount: Int = 3,
        gameDuration: TimeInterval = 60,
        xpGained: Int = 450
    ) {
        self.score = score
        self.correctCount = correctCount
        self.missedCount = missedCount
        self.gameDuration = gameDuration
        self.xpGained = xpGained
        
        // Award XP
        UserProfileService.shared.addXP(xpGained)
        
        // Read updated state for display
        let profile = UserProfileService.shared.userProfile
        self.currentXp = Int(profile.currentXP)
        self.xpRequiredForNextLevel = Int(profile.maxXP)
        
        self.state = .content
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
