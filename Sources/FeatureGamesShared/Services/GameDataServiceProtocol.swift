import Foundation

// MARK: - Game Data Service Protocol
// Protocol for loading game data from JSON files
// Enables dependency injection and testability

public protocol GameDataServiceProtocol: Sendable {
    /// Generic fetch for JSON data
    /// - Parameter fileName: Name of the JSON file (without extension)
    /// - Returns: Array of decoded items
    /// - Throws: AppError if data cannot be loaded or decoded
    func fetchData<T: Decodable>(from fileName: String) async throws -> [T]
    
    /// Loads Connections Game Data
    /// - Returns: Array of GameTile objects
    /// - Throws: AppError if data cannot be loaded
    func loadConnectionsData() async throws -> [GameTile]
    
    /// Loads Over/Under Game Data
    /// - Returns: Array of OverUnderQuestion objects
    /// - Throws: AppError if data cannot be loaded
    func loadOverUnderQuestions() async throws -> [OverUnderQuestion]
    
    /// Loads specific game data by type
    /// - Parameter type: The game type to load data for
    /// - Returns: Array of BallKnowledgeQuestion objects
    /// - Throws: AppError if data cannot be loaded
    func fetchData(for type: GameDataService.GameType) async throws -> [BallKnowledgeQuestion]
    
    /// Loads the list of available games
    /// - Returns: Array of GameItem objects
    /// - Throws: AppError if data cannot be loaded
    func loadGameList() async throws -> [GameItem]
}
