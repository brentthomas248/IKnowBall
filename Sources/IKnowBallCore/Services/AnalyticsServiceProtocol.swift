import Foundation

// MARK: - Analytics Service Protocol
// Protocol for tracking analytics events
// Enables dependency injection and testability

public protocol AnalyticsServiceProtocol: Sendable {
    /// Log a screen view event
    /// - Parameter screenName: Name of the screen being viewed
    func logScreenView(_ screenName: String)
    
    /// Track a custom analytics event
    /// - Parameter event: The event to track
    func track(_ event: AnalyticsEvent)
}
