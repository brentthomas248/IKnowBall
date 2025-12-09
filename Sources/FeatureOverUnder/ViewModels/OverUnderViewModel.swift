import SwiftUI

struct OverUnderQuestion {
    let player: String
    let team: String
    let statContext: String
    let lineValue: Double
    let actualValue: Double
}

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
    
    // Mock Data
    private let questionPool: [OverUnderQuestion] = [
        OverUnderQuestion(player: "Patrick Mahomes", team: "KC", statContext: "Passing Yards (2022)", lineValue: 5100.5, actualValue: 5250),
        OverUnderQuestion(player: "Tyreek Hill", team: "MIA", statContext: "Receiving Yards (2023)", lineValue: 1750.5, actualValue: 1799),
        OverUnderQuestion(player: "Christian McCaffrey", team: "SF", statContext: "Total Scrimmage Yards (2023)", lineValue: 2100.5, actualValue: 2023),
        OverUnderQuestion(player: "Lamar Jackson", team: "BAL", statContext: "Rushing Yards (2019)", lineValue: 1100.5, actualValue: 1206),
        OverUnderQuestion(player: "Justin Jefferson", team: "MIN", statContext: "Receptions (2022)", lineValue: 125.5, actualValue: 128),
        OverUnderQuestion(player: "Cooper Kupp", team: "LAR", statContext: "Receiving Yards (2021)", lineValue: 1900.5, actualValue: 1947),
        OverUnderQuestion(player: "Travis Kelce", team: "KC", statContext: "Receiving Yards (2020)", lineValue: 1400.5, actualValue: 1416),
        OverUnderQuestion(player: "Derrick Henry", team: "TEN", statContext: "Rushing Yards (2020)", lineValue: 2000.5, actualValue: 2027),
        OverUnderQuestion(player: "Josh Allen", team: "BUF", statContext: "Total Touchdowns (2023)", lineValue: 42.5, actualValue: 44),
        OverUnderQuestion(player: "T.J. Watt", team: "PIT", statContext: "Sacks (2021)", lineValue: 21.5, actualValue: 22.5)
    ]
    
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
        loadNextQuestion()
        startTimer()
    }
    
    func submitGuess(isOver: Bool) {
        guard gameState == .playing, let question = currentQuestion else { return }
        
        let actualIsOver = question.actualValue > question.lineValue
        let isCorrect = (isOver == actualIsOver)
        
        if isCorrect {
            score += 1
            correctCount += 1
            lastGuessWasCorrect = true
        } else {
            missedCount += 1
            lastGuessWasCorrect = false
        }
        
        gameState = .showingResult
        
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
            
            await MainActor.run {
                if timeRemaining > 0 {
                    loadNextQuestion()
                } else {
                    endGame()
                }
            }
        }
    }
    
    private func loadNextQuestion() {
        if timeRemaining <= 0 {
            endGame()
            return
        }
        currentQuestion = questionPool.randomElement()
        gameState = .playing
        lastGuessWasCorrect = nil
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
