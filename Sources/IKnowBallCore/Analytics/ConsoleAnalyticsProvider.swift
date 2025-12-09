import Foundation

/// Console-only analytics provider for development
public final class ConsoleAnalyticsProvider: AnalyticsProvider, Sendable {
    
    public init() {}
    
    public func track(event: String, parameters: [String: Any]?) {
        #if DEBUG
        var message = "📊 Event: \(event)"
        if let params = parameters {
            message += " | Params: \(params)"
        }
        print(message)
        #endif
    }
    
    public func setUserProperty(_ value: String, forName name: String) {
        #if DEBUG
        print("👤 User Property: \(name) = \(value)")
        #endif
    }
    
    public func logScreenView(_ screenName: String) {
        #if DEBUG
        print("📱 Screen: \(screenName)")
        #endif
    }
}
