import SwiftUI
import FeatureGamesShared
import IKnowBallCore
import OSLog

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
    var solvedGroups: [SolvedGroup] = []  // NEW: Track solved groups separately
    var mistakesRemaining: Int = 4
    
    // Computed Properties
    var activeTiles: [GameTile] {
        tiles.filter { !$0.isSolved }
    }
    
    // Computed Properties
    var canSubmit: Bool {
        selectedTiles.count == 4
    }
    
    
    var solvedGroupsCount: Int {
        solvedGroups.count
    }
    
    var mistakesMade: Int {
        4 - mistakesRemaining
    }
    
    var score: Int {
        // Simple scoring: 250 points per group, minus 50 per mistake
        let groupPoints = solvedGroupsCount * 250
        let penalty = mistakesMade * 50
        return max(0, groupPoints - penalty)
    }
    
    private var selectedTiles: [GameTile] {
        tiles.filter { $0.isSelected }
    }
    
    private let logger = Logger(subsystem: "com.iknowball", category: "ConnectionGameViewModel")
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        // Track game start
        AnalyticsService.shared.track(.gameStarted(gameType: "connections"))
        
        Task {
            do {
                // Load data with error handling
                let loadedTiles = try await GameDataService.shared.loadConnectionsData()
                
                await MainActor.run {
                    self.tiles = loadedTiles.shuffled()
                    self.solvedGroups = []  // Reset solved groups
                    self.mistakesRemaining = 4
                    self.state = .playing
                    self.showSummary = false
                }
            } catch {
                // Handle error - fall back to empty state
                await MainActor.run {
                    self.tiles = []
                    logger.error("Error loading Connections data: \(error.localizedDescription)")
                }
            }
        }
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
            #if os(iOS)
            HapticManager.shared.notification(type: .success)
            #endif
            
            // Create a SolvedGroup
            let category = firstCategory
            let tileTexts = selectedTiles.map { $0.text }
            let group = SolvedGroup(category: category, tiles: tileTexts)
            solvedGroups.append(group)
            
            // Mark tiles as solved
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
                
                // Track game completion
                AnalyticsService.shared.track(.gameCompleted(
                    gameType: "connections",
                    score: score,
                    timeElapsed: 0 // Connections doesn't have a timer
                ))
            }
        } else {
            // Failure: Decrement mistakes
            if mistakesRemaining > 0 {
                mistakesRemaining -= 1
            }
            
            #if os(iOS)
            HapticManager.shared.notification(type: .error)
            #endif
            
            if mistakesRemaining == 0 {
                state = .gameOver(won: false)
                showSummary = true
                
                // Track game completion
                AnalyticsService.shared.track(.gameCompleted(
                    gameType: "connections",
                    score: score,
                    timeElapsed: 0
                ))
            }
            // Optional: Provide feedback (shake?)
            // For now, simple state change is enough
        }
    }
}
