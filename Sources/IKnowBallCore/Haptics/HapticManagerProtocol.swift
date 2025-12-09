#if canImport(UIKit)
import UIKit
#endif

// MARK: - Haptic Manager Protocol
// Protocol for providing haptic feedback
// Enables dependency injection and testability

public protocol HapticManagerProtocol: Sendable {
    #if os(iOS)
    /// Trigger an impact haptic feedback
    /// - Parameter style: The style of impact (light, medium, heavy)
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle)
    
    /// Trigger a notification haptic feedback
    /// - Parameter type: The type of notification (success, warning, error)
    func notification(type: UINotificationFeedbackGenerator.FeedbackType)
    
    /// Trigger a selection haptic feedback
    func selection()
    #endif
}
