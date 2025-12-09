import SwiftUI
import IKnowBallCore

// OverUnderQuestion is now in FeatureGamesShared
import FeatureGamesShared

@Observable
final class OverUnderViewModel {
    
    enum GameState {
        case playing
        case showingResult
        case gameOver
    }
    
    // MARK: - Properties
    
    var gameState: GameState = .playing
    var currentQuestion: OverUnderQuestion?
    var score: Int = 0
    var timeRemaining: Int = 60
    
    // Stats
    var correctCount: Int = 0
    var missedCount: Int = 0
    var showSummary: Bool = false
    
    // Internal State
    var lastGuessWasCorrect: Bool?
    private var timer: Timer?
    
    // Data
    private var questionPool: [OverUnderQuestion] = []
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        score = 0
        correctCount = 0
        missedCount = 0
        showSummary = false
        timeRemaining = 60
        lastGuessWasCorrect = nil
        
        Task {
            await loadNextQuestion()
            await MainActor.run {
                startTimer()
            }
        }
    }
    
    func submitGuess(isOver: Bool) {
        guard gameState == .playing, let question = currentQuestion else { return }
        
        let actualIsOver = question.actualValue > question.lineValue
        let isCorrect = (isOver == actualIsOver)
        
        if isCorrect {
            score += 1
            correctCount += 1
            lastGuessWasCorrect = true
            HapticManager.shared.notification(type: .success)
        } else {
            missedCount += 1
            lastGuessWasCorrect = false
            HapticManager.shared.notification(type: .error)
        }
        
        gameState = .showingResult
        
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            
            if timeRemaining > 0 {
                await loadNextQuestion()
            } else {
                await MainActor.run {
                    endGame()
                }
            }
        }
    }
    
    private func loadNextQuestion() async {
        if timeRemaining <= 0 {
            await MainActor.run { endGame() }
            return
        }
        
        if questionPool.isEmpty {
            let questions = await GameDataService.shared.loadOverUnderQuestions()
            await MainActor.run {
                self.questionPool = questions
            }
        }
        
        await MainActor.run {
            currentQuestion = questionPool.randomElement()
            gameState = .playing
            lastGuessWasCorrect = nil
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.endGame()
            }
        }
    }
    
    private func endGame() {
        gameState = .gameOver
        timer?.invalidate()
        timer = nil
        showSummary = true
    }
}
