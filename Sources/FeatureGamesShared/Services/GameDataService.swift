import Foundation
import IKnowBallCore

public final class GameDataService: GameDataServiceProtocol {
    public static let shared = GameDataService()
    
    private init() {}
    
    /// Generic fetch for JSON data
    /// - Throws: AppError if data cannot be loaded or decoded
    public func fetchData<T: Decodable>(from fileName: String) async throws -> [T] {
        guard let url = Bundle.module.url(forResource: fileName, withExtension: "json") else {
            print("❌ GameDataService: Could not find \(fileName).json in bundle.")
            throw AppError.dataNotFound(fileName: fileName)
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let items = try decoder.decode([T].self, from: data)
            
            guard !items.isEmpty else {
                print("⚠️ GameDataService: \(fileName).json returned empty array")
                throw AppError.emptyDataSet(fileName: fileName)
            }
            
            print("✅ GameDataService: Successfully loaded \(items.count) items from \(fileName).json")
            return items
        } catch let decodingError as DecodingError {
            let reason: String
            switch decodingError {
            case .dataCorrupted(let context):
                reason = "Data corrupted: \(context.debugDescription)"
            case .keyNotFound(let key, let context):
                reason = "Key '\(key.stringValue)' not found: \(context.debugDescription)"
            case .typeMismatch(let type, let context):
                reason = "Type mismatch for \(type): \(context.debugDescription)"
            case .valueNotFound(let type, let context):
                reason = "Value not found for \(type): \(context.debugDescription)"
            @unknown default:
                reason = "Unknown decoding error"
            }
            
            print("❌ GameDataService: Failed to decode \(fileName).json. Error: \(reason)")
            
            // Print raw string to debug JSON format issues
            #if DEBUG
            if let string = try? String(contentsOf: url) {
                print("📋 Raw JSON content (first 500 chars): \(string.prefix(500))")
            }
            #endif
            
            throw AppError.invalidData(fileName: fileName, reason: reason)
        } catch let appError as AppError {
            // Re-throw AppErrors
            throw appError
        } catch {
            // Catch-all for other errors
            print("❌ GameDataService: Unexpected error loading \(fileName).json: \(error)")
            throw AppError.invalidData(fileName: fileName, reason: error.localizedDescription)
        }
    }
    
    public enum GameType {
        case ballKnowledge
    }

    /// Loads Connections Game Data
    /// - Throws: AppError if data cannot be loaded
    public func loadConnectionsData() async throws -> [GameTile] {
        return try await fetchData(from: "connections_data")
    }
    
    /// Loads Over/Under Game Data
    /// - Throws: AppError if data cannot be loaded
    public func loadOverUnderQuestions() async throws -> [OverUnderQuestion] {
        return try await fetchData(from: "over_under_data")
    }
    
    /// Loads specific game data by type
    /// - Throws: AppError if data cannot be loaded
    public func fetchData(for type: GameType) async throws -> [BallKnowledgeQuestion] {
        switch type {
        case .ballKnowledge:
            return try await fetchData(from: "ball_knowledge_questions")
        }
    }
    
    /// Loads the list of available games
    /// - Throws: AppError if data cannot be loaded
    public func loadGameList() async throws -> [GameItem] {
        return try await fetchData(from: "games_config")
    }
}
