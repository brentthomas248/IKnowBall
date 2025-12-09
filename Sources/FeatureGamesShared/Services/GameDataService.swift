import Foundation

public final class GameDataService: Sendable {
    public static let shared = GameDataService()
    
    private init() {}
    
    /// Generic fetch for JSON data
    public func fetchData<T: Decodable>(from fileName: String) async -> [T] {
        guard let url = Bundle.module.url(forResource: fileName, withExtension: "json") else {
            print("❌ GameDataService: Could not find \(fileName).json in bundle.")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let items = try decoder.decode([T].self, from: data)
            print("✅ GameDataService: Successfully loaded \(items.count) items from \(fileName).json")
            return items
        } catch {
            print("❌ GameDataService: Failed to decode \(fileName).json. Error: \(error)")
            // Print raw string to debug JSON format issues
            if let string = try? String(contentsOf: url) {
                print("📋 Raw JSON content: \(string)")
            }
            return []
        }
    }
    
    public enum GameType {
        case ballKnowledge
    }

    /// Loads Connections Game Data
    public func loadConnectionsData() async -> [GameTile] {
        return await fetchData(from: "connections_data")
    }
    
    /// Loads Over/Under Game Data
    public func loadOverUnderQuestions() async -> [OverUnderQuestion] {
        return await fetchData(from: "over_under_data")
    }
    
    /// Loads specific game data by type
    public func fetchData(for type: GameType) async -> [BallKnowledgeQuestion] {
        switch type {
        case .ballKnowledge:
            return await fetchData(from: "ball_knowledge_questions")
        }
    }
    
    /// Loads the list of available games
    public func loadGameList() async -> [GameItem] {
        return await fetchData(from: "games_config")
    }
}
