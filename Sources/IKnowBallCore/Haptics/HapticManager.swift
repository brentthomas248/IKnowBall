#if canImport(UIKit)
import UIKit
#endif

/// Centralized manager for Haptic Feedback
public final class HapticManager: HapticManagerProtocol {
    public static let shared = HapticManager()
    
    private init() {}
    
    #if os(iOS)
    /// Trigger an impact haptic feedback
    public func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    /// Trigger a notification haptic feedback
    public func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    /// Trigger a selection haptic feedback
    public func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    #else
    // macOS stubs - no-op implementations
    public func impact(style: Any) {}
    public func notification(type: Any) {}
    public func selection() {}
    #endif
}
