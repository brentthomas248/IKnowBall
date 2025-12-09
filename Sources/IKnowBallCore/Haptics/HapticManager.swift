#if canImport(UIKit)
import UIKit
#endif

/// Centralized manager for Haptic Feedback
public final class HapticManager {
    public static let shared = HapticManager()
    
    private init() {}
    
    /// Trigger a notification feedback (success, warning, error)
    public func notification(type: NotificationType) {
        #if canImport(UIKit)
        let generator = UINotificationFeedbackGenerator()
        switch type {
        case .success: generator.notificationOccurred(.success)
        case .warning: generator.notificationOccurred(.warning)
        case .error: generator.notificationOccurred(.error)
        }
        #endif
    }
    
    /// Trigger an impact feedback
    public func impact(style: ImpactStyle) {
        #if canImport(UIKit)
        let generator: UIImpactFeedbackGenerator
        switch style {
        case .light: generator = UIImpactFeedbackGenerator(style: .light)
        case .medium: generator = UIImpactFeedbackGenerator(style: .medium)
        case .heavy: generator = UIImpactFeedbackGenerator(style: .heavy)
        case .rigid: generator = UIImpactFeedbackGenerator(style: .rigid)
        case .soft: generator = UIImpactFeedbackGenerator(style: .soft)
        }
        generator.impactOccurred()
        #endif
    }
    
    /// Trigger a selection change feedback
    public func selection() {
        #if canImport(UIKit)
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
        #endif
    }
    
    // Abstracted types to avoid UIKit dependency in signature
    public enum NotificationType {
        case success, warning, error
    }
    
    public enum ImpactStyle {
        case light, medium, heavy, rigid, soft
    }
}
