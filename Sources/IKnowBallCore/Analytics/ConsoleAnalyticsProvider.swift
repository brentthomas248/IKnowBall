import Foundation
import OSLog

/// Console-only analytics provider for development
/// Uses OSLog for proper structured logging
public final class ConsoleAnalyticsProvider: AnalyticsProvider, Sendable {
    
    private let logger = Logger(subsystem: "com.iknowball", category: "Analytics")
    
    public init() {}
    
    public func track(event: String, parameters: [String: Any]?) {
        #if DEBUG
        var message = "Event: \(event)"
        if let params = parameters {
            message += " | Params: \(params)"
        }
        logger.debug("\(message)")
        #endif
    }
    
    public func setUserProperty(_ value: String, forName name: String) {
        #if DEBUG
        logger.debug("User Property: \(name) = \(value)")
        #endif
    }
    
    public func logScreenView(_ screenName: String) {
        #if DEBUG
        logger.debug("Screen: \(screenName)")
        #endif
    }
}
