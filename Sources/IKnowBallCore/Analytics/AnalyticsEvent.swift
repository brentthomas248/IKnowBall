import Foundation

/// Strongly-typed analytics events
public enum AnalyticsEvent {
    // App Lifecycle
    case appLaunched
    case appBackgrounded
    case appForegrounded
    
    // Game Events
    case gameStarted(gameType: String)
    case gameCompleted(gameType: String, score: Int, timeElapsed: Int)
    case gameAbandoned(gameType: String, timeElapsed: Int)
    
    // Navigation
    case screenViewed(screenName: String)
    case buttonTapped(buttonName: String, screenName: String)
    
    // Settings
    case settingChanged(setting: String, value: String)
    
    // Errors
    case errorOccurred(errorType: String, context: String)
    
    /// Convert event to (name, parameters) tuple
    var eventData: (String, [String: Any]?) {
        switch self {
        case .appLaunched:
            return ("app_launched", nil)
        case .appBackgrounded:
            return ("app_backgrounded", nil)
        case .appForegrounded:
            return ("app_foregrounded", nil)
            
        case .gameStarted(let gameType):
            return ("game_started", ["game_type": gameType])
            
        case .gameCompleted(let gameType, let score, let timeElapsed):
            return ("game_completed", [
                "game_type": gameType,
                "score": score,
                "time_elapsed_seconds": timeElapsed
            ])
            
        case .gameAbandoned(let gameType, let timeElapsed):
            return ("game_abandoned", [
                "game_type": gameType,
                "time_elapsed_seconds": timeElapsed
            ])
            
        case .screenViewed(let screenName):
            return ("screen_viewed", ["screen_name": screenName])
            
        case .buttonTapped(let buttonName, let screenName):
            return ("button_tapped", [
                "button_name": buttonName,
                "screen_name": screenName
            ])
            
        case .settingChanged(let setting, let value):
            return ("setting_changed", [
                "setting": setting,
                "value": value
            ])
            
        case .errorOccurred(let errorType, let context):
            return ("error_occurred", [
                "error_type": errorType,
                "context": context
            ])
        }
    }
}
