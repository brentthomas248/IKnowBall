import Foundation
import OSLog

/// Protocol for analytics providers
public protocol AnalyticsProvider: Sendable {
    func track(event: String, parameters: [String: Any]?)
    func setUserProperty(_ value: String, forName name: String)
    func logScreenView(_ screenName: String)
}

/// Centralized analytics service
@Observable
public final class AnalyticsService: AnalyticsServiceProtocol {
    public static let shared = AnalyticsService()
    
    private let provider: AnalyticsProvider
    private let logger = Logger(subsystem: "com.iknowball", category: "Analytics")
    
    /// Check if analytics is enabled (respects user preference)
    public var isEnabled: Bool {
        UserDefaults.standard.bool(forKey: "analytics_enabled")
    }
    
    private init(provider: AnalyticsProvider = ConsoleAnalyticsProvider()) {
        self.provider = provider
        
        // Default to enabled on first launch
        if UserDefaults.standard.object(forKey: "analytics_enabled") == nil {
            UserDefaults.standard.set(true, forKey: "analytics_enabled")
        }
    }
    
    /// Track an analytics event
    public func track(_ event: AnalyticsEvent) {
        guard isEnabled else { return }
        
        let (eventName, parameters) = event.eventData
        
        #if DEBUG
        logger.info("📊 Analytics: \(eventName) - \(String(describing: parameters))")
        #endif
        
        provider.track(event: eventName, parameters: parameters)
    }
    
    /// Log a screen view
    public func logScreenView(_ screenName: String) {
        guard isEnabled else { return }
        
        #if DEBUG
        logger.info("📱 Screen View: \(screenName)")
        #endif
        
        provider.logScreenView(screenName)
    }
    
    /// Set analytics enabled/disabled
    public func setEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: "analytics_enabled")
    }
}
