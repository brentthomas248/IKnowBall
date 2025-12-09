import Foundation
import SwiftUI

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
        self.tiles = [
            // Tier 1 (Gold)
            GameTileModel(id: UUID(), stat: "5,477 Yds", teamAbbr: "DEN", playerName: "Peyton Manning", isRevealed: false, tier: 1),
            GameTileModel(id: UUID(), stat: "5,476 Yds", teamAbbr: "NO", playerName: "Drew Brees", isRevealed: false, tier: 1),
            GameTileModel(id: UUID(), stat: "5,235 Yds", teamAbbr: "NE", playerName: "Tom Brady", isRevealed: false, tier: 1),
            GameTileModel(id: UUID(), stat: "5,129 Yds", teamAbbr: "PIT", playerName: "Ben Roethlisberger", isRevealed: false, tier: 1),
            GameTileModel(id: UUID(), stat: "5,109 Yds", teamAbbr: "TB", playerName: "Jameis Winston", isRevealed: false, tier: 1),
            GameTileModel(id: UUID(), stat: "5,097 Yds", teamAbbr: "KC", playerName: "Patrick Mahomes", isRevealed: false, tier: 1),
            GameTileModel(id: UUID(), stat: "5,038 Yds", teamAbbr: "DET", playerName: "Matthew Stafford", isRevealed: false, tier: 1),

            // Tier 2 (Silver)
            GameTileModel(id: UUID(), stat: "4,944 Yds", teamAbbr: "ATL", playerName: "Matt Ryan", isRevealed: false, tier: 2),
            GameTileModel(id: UUID(), stat: "4,933 Yds", teamAbbr: "NYG", playerName: "Eli Manning", isRevealed: false, tier: 2),
            GameTileModel(id: UUID(), stat: "4,917 Yds", teamAbbr: "WAS", playerName: "Kirk Cousins", isRevealed: false, tier: 2),
            GameTileModel(id: UUID(), stat: "4,903 Yds", teamAbbr: "DAL", playerName: "Tony Romo", isRevealed: false, tier: 2),
            GameTileModel(id: UUID(), stat: "4,902 Yds", teamAbbr: "DAL", playerName: "Dak Prescott", isRevealed: false, tier: 2),
            GameTileModel(id: UUID(), stat: "4,761 Yds", teamAbbr: "IND", playerName: "Andrew Luck", isRevealed: false, tier: 2),
            GameTileModel(id: UUID(), stat: "4,710 Yds", teamAbbr: "SD", playerName: "Philip Rivers", isRevealed: false, tier: 2),

            // Tier 3 (Bronze)
            GameTileModel(id: UUID(), stat: "4,688 Yds", teamAbbr: "LAR", playerName: "Jared Goff", isRevealed: false, tier: 3),
            GameTileModel(id: UUID(), stat: "4,671 Yds", teamAbbr: "ARI", playerName: "Carson Palmer", isRevealed: false, tier: 3),
            GameTileModel(id: UUID(), stat: "4,643 Yds", teamAbbr: "GB", playerName: "Aaron Rodgers", isRevealed: false, tier: 3),
            GameTileModel(id: UUID(), stat: "4,317 Yds", teamAbbr: "BAL", playerName: "Joe Flacco", isRevealed: false, tier: 3),
            GameTileModel(id: UUID(), stat: "4,293 Yds", teamAbbr: "CIN", playerName: "Andy Dalton", isRevealed: false, tier: 3),
            GameTileModel(id: UUID(), stat: "4,219 Yds", teamAbbr: "SEA", playerName: "Russell Wilson", isRevealed: false, tier: 3)
        ]
        
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
            currentInput = ""
        } else {
            // Incorrect Guess
            missedCount += 1
            timeRemaining = max(0, timeRemaining - 10)
            // Ideally trigger shake feedback here via a published property
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
