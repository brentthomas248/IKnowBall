import Foundation
import SwiftUI
import FeatureGamesShared
import IKnowBallCore

/// Represents a single tile in the game grid
struct GameTileModel: Identifiable {
    let id: UUID
    let stat: String
    let teamAbbr: String
    let playerName: String
    var isRevealed: Bool
    let tier: Int
}

enum GameState {
    case idle
    case playing
    case finished
}

@Observable
class BallKnowledgeViewModel {
    
    // MARK: - Properties
    
    var score: Int = 0
    var timeRemaining: Int = 120
    var currentInput: String = ""
    var state: GameState = .idle
    var showSummary: Bool = false
    
    var correctCount: Int = 0
    var missedCount: Int = 0
    
    var tiles: [GameTileModel] = []
    
    private var timer: Timer?
    
    var isGameOver: Bool {
        state == .finished
    }
    
    // MARK: - Initialization
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        // Reset State
        score = 0
        timeRemaining = 120
        currentInput = ""
        state = .idle
        showSummary = false
        correctCount = 0
        missedCount = 0
        
        // Reset Data
        // Load Data from Service
        let questions = GameDataService.shared.loadBallKnowledgeQuestions()
        self.tiles = questions.map { question in
            GameTileModel(
                id: UUID(),
                stat: question.stat,
                teamAbbr: question.teamAbbr,
                playerName: question.playerName,
                isRevealed: false,
                tier: question.tier
            )
        }
        
        startTimer()
    }
    
    // MARK: - Game Logic
    
    func startTimer() {
        state = .playing
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.endGame()
            }
        }
    }
    
    func submitGuess() {
        guard !currentInput.isEmpty, state == .playing else { return }
        
        let guess = currentInput.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        var matchFound = false
        
        // Check for matches
        for index in tiles.indices {
            let tile = tiles[index]
            if !tile.isRevealed && tile.playerName.lowercased() == guess {
                // Correct Guess
                tiles[index].isRevealed = true
                score += points(for: tile.tier)
                correctCount += 1
                matchFound = true
            }
        }
        
        // Check win condition
        let allRevealed = tiles.allSatisfy { $0.isRevealed }
        if allRevealed {
            endGame()
        }
        
        if matchFound {
            HapticManager.shared.notification(type: .success)
            currentInput = ""
        } else {
            // Incorrect Guess
            missedCount += 1
            timeRemaining = max(0, timeRemaining - 10)
            HapticManager.shared.notification(type: .error)
        }
    }
    
    private func points(for tier: Int) -> Int {
        switch tier {
        case 1: return 100
        case 2: return 150
        case 3: return 200
        default: return 50
        }
    }
    
    private func endGame() {
        state = .finished
        showSummary = true
        timer?.invalidate()
        timer = nil
    }
}
