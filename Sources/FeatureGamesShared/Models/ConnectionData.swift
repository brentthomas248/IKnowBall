import Foundation

/// Internal model for JSON decoding
struct ConnectionData: Codable {
    let text: String
    let category: String
    let groupName: String // Optional extra metadata
}
