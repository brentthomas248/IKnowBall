import SwiftUI

@Observable
final class ConnectionGameViewModel {
    enum State {
        case playing
        case gameOver(won: Bool)
    }
    
    // Game State
    var state: State = .playing
    var tiles: [GameTile] = []
    var mistakesRemaining: Int = 4
    
    // Computed Properties
    var canSubmit: Bool {
        selectedTiles.count == 4
    }
    
    private var selectedTiles: [GameTile] {
        tiles.filter { $0.isSelected }
    }
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        // Data Groups
        let positions = ["Quarterback", "Receiver", "Lineman", "Kicker"].map { GameTile(text: $0, category: "Positions") }
        let scoring = ["Touchdown", "Field Goal", "Safety", "Convert"].map { GameTile(text: $0, category: "Scoring") }
        let gear = ["Helmet", "Pads", "Cleats", "Jersey"].map { GameTile(text: $0, category: "Gear") }
        let office = ["Draft", "Trade", "Waiver", "Contract"].map { GameTile(text: $0, category: "Front Office") }
        
        tiles = (positions + scoring + gear + office).shuffled()
        mistakesRemaining = 4
        state = .playing
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
            for tile in selectedTiles {
                if let index = tiles.firstIndex(where: { $0.id == tile.id }) {
                    tiles[index].isSolved = true
                    tiles[index].isSelected = false
                }
            }
            // Check for overall win
            if tiles.allSatisfy({ $0.isSolved }) {
                state = .gameOver(won: true)
            }
        } else {
            // Failure: Decrement mistakes
            if mistakesRemaining > 0 {
                mistakesRemaining -= 1
            }
            
            if mistakesRemaining == 0 {
                state = .gameOver(won: false)
            }
            // Optional: Provide feedback (shake?)
            // For now, simple state change is enough
        }
    }
}
