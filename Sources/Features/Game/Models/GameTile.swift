import Foundation

struct GameTile: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let category: String // New: To identify which group it belongs to
    var isSelected: Bool = false
    var isSolved: Bool = false // New: To visually remove/highlight solved tiles
}
