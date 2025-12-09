import SwiftUI
import FeatureGamesShared
import IKnowBallCore

@Observable
final class ConnectionGameViewModel {
    enum State {
        case playing
        case gameOver(won: Bool)
    }
    
    // Game State
    var state: State = .playing
    var showSummary: Bool = false
    
    var tiles: [GameTile] = []
    var mistakesRemaining: Int = 4
    
    // Computed Properties
    var canSubmit: Bool {
        selectedTiles.count == 4
    }
    
    var solvedGroups: Int {
        tiles.filter { $0.isSolved }.count / 4
    }
    
    var mistakesMade: Int {
        4 - mistakesRemaining
    }
    
    var score: Int {
        // Simple scoring: 250 points per group, minus 50 per mistake
        let groupPoints = solvedGroups * 250
        let penalty = mistakesMade * 50
        return max(0, groupPoints - penalty)
    }
    
    private var selectedTiles: [GameTile] {
        tiles.filter { $0.isSelected }
    }
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        // Data Groups
        let loadedTiles = GameDataService.shared.loadConnectionsData()
        
        if loadedTiles.isEmpty {
            // Fallback if load fails (or for robustness)
            print("Warning: Failed to load Connections data")
        }
        
        tiles = loadedTiles.shuffled()
        mistakesRemaining = 4
        state = .playing
        showSummary = false
    }
    
    func toggleSelection(_ tile: GameTile) {
        guard let index = tiles.firstIndex(where: { $0.id == tile.id }) else { return }
        
        // If solved, ignore
        if tiles[index].isSolved { return }
        
        // If selecting (currently false) and already have 4, do nothing
        if !tiles[index].isSelected && selectedTiles.count >= 4 {
            return
        }
        
        tiles[index].isSelected.toggle()
    }
    
    func shuffle() {
        tiles.shuffle()
    }
    
    func deselectAll() {
        for i in tiles.indices where !tiles[i].isSolved {
            tiles[i].isSelected = false
        }
    }
    
    func submit() {
        guard canSubmit else { return }
        
        // Validation Logic
        let firstCategory = selectedTiles[0].category
        let isMatch = selectedTiles.allSatisfy { $0.category == firstCategory }
        
        if isMatch {
            // Success: Mark as solved
            HapticManager.shared.notification(type: .success)
            for tile in selectedTiles {
                if let index = tiles.firstIndex(where: { $0.id == tile.id }) {
                    tiles[index].isSolved = true
                    tiles[index].isSelected = false
                }
            }
            // Check for overall win
            if tiles.allSatisfy({ $0.isSolved }) {
                state = .gameOver(won: true)
                showSummary = true
            }
        } else {
            // Failure: Decrement mistakes
            if mistakesRemaining > 0 {
                mistakesRemaining -= 1
            }
            
            HapticManager.shared.notification(type: .error)
            
            if mistakesRemaining == 0 {
                state = .gameOver(won: false)
                showSummary = true
            }
            // Optional: Provide feedback (shake?)
            // For now, simple state change is enough
        }
    }
}
