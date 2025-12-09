import Foundation

public enum GameType {
    case ballKnowledge
    // Add other cases as needed
}

public class GameDataService {
    public static let shared = GameDataService()
    
    private init() {}
    
    public func loadBallKnowledgeQuestions() -> [BallKnowledgeQuestion] {
        return loadJSON(filename: "ball_knowledge_questions")
    }
    
    public func loadConnectionsData() -> [GameTile] {
        let data: [ConnectionData] = loadJSON(filename: "connections_data")
        return data.map {
            GameTile(text: $0.text, category: $0.category)
        }
    }
    
    public func loadOverUnderQuestions() -> [OverUnderQuestion] {
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
