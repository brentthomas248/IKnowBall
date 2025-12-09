import Foundation

public struct GameTile: Identifiable, Equatable {
    public let id: UUID
    public let text: String
    public let category: String // New: To identify which group it belongs to
    public var isSelected: Bool
    public var isSolved: Bool // New: To visually remove/highlight solved tiles

    public init(text: String, category: String, isSelected: Bool = false, isSolved: Bool = false) {
        self.id = UUID()
        self.text = text
        self.category = category
        self.isSelected = isSelected
        self.isSolved = isSolved
    }
}
