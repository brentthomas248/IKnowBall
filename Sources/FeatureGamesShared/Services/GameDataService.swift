import Foundation

public enum GameType {
    case ballKnowledge
    // Add other cases as needed
}

public class GameDataService {
    public static let shared = GameDataService()
    
    private init() {}
    
    public func loadBallKnowledgeQuestions() async -> [BallKnowledgeQuestion] {
        // Simulate network/disk delay
        try? await Task.sleep(nanoseconds: 100_000_000) // 0.1s
        return loadJSON(filename: "ball_knowledge_questions")
    }
    
    public func loadConnectionsData() async -> [GameTile] {
        try? await Task.sleep(nanoseconds: 100_000_000)
        let data: [ConnectionData] = loadJSON(filename: "connections_data")
        return data.map {
            GameTile(text: $0.text, category: $0.category)
        }
    }
    
    public func loadOverUnderQuestions() async -> [OverUnderQuestion] {
        try? await Task.sleep(nanoseconds: 100_000_000)
        return loadJSON(filename: "over_under_data")
    }
    
    private func loadJSON<T: Decodable>(filename: String) -> [T] {
        guard let url = Bundle.module.url(forResource: filename, withExtension: "json") else {
            print("Failed to find JSON: \(filename)")
            return []
        }
        
        do {
            let data = try Data(contentsOf: url)
            let result = try JSONDecoder().decode([T].self, from: data)
            return result
        } catch {
            print("Failed to decode JSON \(filename): \(error)")
            return []
        }
    }
}
