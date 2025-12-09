import Foundation

public struct GameItem: Identifiable, Codable, Equatable {
    public let id: String
    public let title: String
    public let iconName: String

    public init(id: String, title: String, iconName: String) {
        self.id = id
        self.title = title
        self.iconName = iconName
    }
}
