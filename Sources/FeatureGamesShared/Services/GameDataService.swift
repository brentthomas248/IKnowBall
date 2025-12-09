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
            // Optional: Handle snake_case to camelCase if needed, but defaults are usually fine if JSON matches
            // decoder.keyDecodingStrategy = .convertFromSnakeCase 
            let items = try decoder.decode([T].self, from: data)
            return items
        } catch {
            print("❌ GameDataService: Failed to decode \(fileName).json. Error: \(error)")
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
}
