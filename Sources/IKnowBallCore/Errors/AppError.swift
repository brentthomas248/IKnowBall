import Foundation

/// App-specific error types with user-friendly messages
/// All errors conform to LocalizedError for proper message display
public enum AppError: LocalizedError {
    
    // MARK: - Data Loading Errors
    
    /// JSON file not found in bundle
    case dataNotFound(fileName: String)
    
    /// JSON data could not be decoded
    case invalidData(fileName: String, reason: String)
    
    /// Empty array returned when data expected
    case emptyDataSet(fileName: String)
    
    // MARK: - Game State Errors
    
    /// Invalid state transition attempted
    case invalidStateTransition(from: String, to: String)
    
    /// Game action attempted in wrong state
    case invalidGameAction(action: String, currentState: String)
    
    // MARK: - User Input Errors
    
    /// User input failed validation
    case invalidInput(field: String, reason: String)
    
    /// Required field is missing
    case missingRequiredField(field: String)
    
    // MARK: - Persistence Errors
    
    /// Failed to save data to UserDefaults
    case saveFailed(key: String, reason: String)
    
    /// Failed to load data from UserDefaults
    case loadFailed(key: String)
    
    // MARK: - LocalizedError Conformance
    
    public var errorDescription: String? {
        switch self {
        case .dataNotFound(let fileName):
            return "Game data not found"
        case .invalidData(let fileName, _):
            return "Game data is invalid"
        case .emptyDataSet:
            return "No game content available"
        case .invalidStateTransition:
            return "Invalid game state"
        case .invalidGameAction(let action, _):
            return "Cannot \(action) right now"
        case .invalidInput(let field, _):
            return "Invalid \(field)"
        case .missingRequiredField(let field):
            return "\(field) is required"
        case .saveFailed:
            return "Failed to save progress"
        case .loadFailed:
            return "Failed to load data"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .dataNotFound:
            return "Try restarting the app"
        case .invalidData:
            return "Try restarting the app"
        case .emptyDataSet:
            return "Check back later for new content"
        case .invalidStateTransition, .invalidGameAction:
            return "Start a new game"
        case .invalidInput(_, let reason):
            return reason
        case .missingRequiredField:
            return "Please provide a value"
        case .saveFailed:
            return "Check storage permissions"
        case .loadFailed:
            return "Try restarting the app"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .dataNotFound(let fileName):
            return "File '\(fileName).json' not found in bundle"
        case .invalidData(let fileName, let reason):
            return "Cannot parse '\(fileName).json': \(reason)"
        case .emptyDataSet(let fileName):
            return "'\(fileName).json' returned empty array"
        case .invalidStateTransition(let from, let to):
            return "Cannot transition from \(from) to \(to)"
        case .invalidGameAction(let action, let state):
            return "Action '\(action)' not allowed in state '\(state)'"
        case .invalidInput(let field, let reason):
            return "\(field): \(reason)"
        case .missingRequiredField(let field):
            return "Field '\(field)' cannot be empty"
        case .saveFailed(let key, let reason):
            return "Cannot save '\(key)': \(reason)"
        case .loadFailed(let key):
            return "Cannot load '\(key)' from storage"
        }
    }
}

// MARK: - Error Severity

public extension AppError {
    
    /// Error severity level for logging and UI display
    enum Severity {
        case low        // Informational, can ignore
        case medium     // Warning, degrades experience
        case high       // Error, blocks functionality
        case critical   // Fatal, app may need restart
    }
    
    var severity: Severity {
        switch self {
        case .invalidInput, .missingRequiredField:
            return .low
        case .emptyDataSet, .invalidGameAction:
            return .medium
        case .dataNotFound, .invalidData, .loadFailed:
            return .high
        case .invalidStateTransition, .saveFailed:
            return .high
        }
    }
    
    var canRetry: Bool {
        switch self {
        case .dataNotFound, .invalidData, .loadFailed:
            return true
        case .emptyDataSet:
            return false
        case .invalidStateTransition, .invalidGameAction:
            return false
        case .invalidInput, .missingRequiredField:
            return false
        case .saveFailed:
            return true
        }
    }
}
