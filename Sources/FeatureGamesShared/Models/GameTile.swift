import Foundation

public struct GameTile: Identifiable, Equatable, Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case text, category
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.text = try container.decode(String.self, forKey: .text)
        self.category = try container.decode(String.self, forKey: .category)
        
        // Default state
        self.id = UUID()
        self.isSelected = false
        self.isSolved = false
    }
}
