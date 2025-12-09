import Foundation

struct GameItem: Identifiable, Codable, Equatable {
    let id: String
    let title: String
    let iconName: String
}
