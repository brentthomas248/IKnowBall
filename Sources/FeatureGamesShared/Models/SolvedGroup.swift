import Foundation

public struct SolvedGroup: Identifiable, Equatable {
    public let id: UUID
    public let category: String
    public let tiles: [String]  // Text of the tiles in this group
    
    public init(category: String, tiles: [String]) {
        self.id = UUID()
        self.category = category
        self.tiles = tiles
    }
}
