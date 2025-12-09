import SwiftUI

// MARK: - Semantic Color Tokens
// Production-grade color system supporting light/dark mode
// Following iOS Human Interface Guidelines

public extension Color {
    
    // MARK: - Brand Colors
    
    /// Primary brand color - Basketball orange
    static let appPrimary = Color(
        light: Color(hue: 0.08, saturation: 0.85, brightness: 0.95),
        dark: Color(hue: 0.08, saturation: 0.75, brightness: 0.85)
    )
    
    /// Secondary brand color - Court blue
    static let appSecondary = Color(
        light: Color(hue: 0.58, saturation: 0.65, brightness: 0.85),
        dark: Color(hue: 0.58, saturation: 0.55, brightness: 0.75)
    )
    
    /// Accent color - Victory gold
    static let appAccent = Color(
        light: Color(hue: 0.12, saturation: 0.80, brightness: 0.92),
        dark: Color(hue: 0.12, saturation: 0.70, brightness: 0.82)
    )
    
    // MARK: - Semantic State Colors
    
    /// Success state - Green
    static let appSuccess = Color(
        light: Color(hue: 0.33, saturation: 0.70, brightness: 0.65),
        dark: Color(hue: 0.33, saturation: 0.60, brightness: 0.75)
    )
    
    /// Error state - Red
    static let appError = Color(
        light: Color(hue: 0.01, saturation: 0.75, brightness: 0.85),
        dark: Color(hue: 0.01, saturation: 0.65, brightness: 0.75)
    )
    
    /// Warning state - Amber
    static let appWarning = Color(
        light: Color(hue: 0.10, saturation: 0.85, brightness: 0.90),
        dark: Color(hue: 0.10, saturation: 0.75, brightness: 0.80)
    )
    
    /// Info state - Blue
    static let appInfo = Color(
        light: Color(hue: 0.55, saturation: 0.65, brightness: 0.85),
        dark: Color(hue: 0.55, saturation: 0.55, brightness: 0.75)
    )
    
    // MARK: - Background Colors
    
    /// Primary background
    static let appBackground = Color(
        light: Color(hue: 0.0, saturation: 0.0, brightness: 0.98),
        dark: Color(hue: 0.0, saturation: 0.0, brightness: 0.08)
    )
    
    /// Secondary background (slightly elevated)
    static let appBackgroundSecondary = Color(
        light: Color(hue: 0.0, saturation: 0.0, brightness: 0.95),
        dark: Color(hue: 0.0, saturation: 0.0, brightness: 0.12)
    )
    
    /// Surface color for cards and elevated content
    static let appSurface = Color(
        light: Color.white,
        dark: Color(hue: 0.0, saturation: 0.0, brightness: 0.15)
    )
    
    /// Surface variant for nested cards
    static let appSurfaceVariant = Color(
        light: Color(hue: 0.0, saturation: 0.0, brightness: 0.96),
        dark: Color(hue: 0.0, saturation: 0.0, brightness: 0.18)
    )
    
    // MARK: - Text Colors
    
    /// Primary text color
    static let appTextPrimary = Color(
        light: Color(hue: 0.0, saturation: 0.0, brightness: 0.12),
        dark: Color(hue: 0.0, saturation: 0.0, brightness: 0.95)
    )
    
    /// Secondary text color (less emphasis)
    static let appTextSecondary = Color(
        light: Color(hue: 0.0, saturation: 0.0, brightness: 0.40),
        dark: Color(hue: 0.0, saturation: 0.0, brightness: 0.70)
    )
    
    /// Tertiary text color (least emphasis)
    static let appTextTertiary = Color(
        light: Color(hue: 0.0, saturation: 0.0, brightness: 0.55),
        dark: Color(hue: 0.0, saturation: 0.0, brightness: 0.50)
    )
    
    /// Text on primary color background
    static let appTextOnPrimary = Color.white
    
    // MARK: - Border & Divider Colors
    
    /// Border color
    static let appBorder = Color(
        light: Color(hue: 0.0, saturation: 0.0, brightness: 0.85),
        dark: Color(hue: 0.0, saturation: 0.0, brightness: 0.25)
    )
    
    /// Divider color (more subtle)
    static let appDivider = Color(
        light: Color(hue: 0.0, saturation: 0.0, brightness: 0.90),
        dark: Color(hue: 0.0, saturation: 0.0, brightness: 0.20)
    )
    
    // MARK: - Overlay Colors
    
    /// Overlay for modals and sheets
    static let appOverlay = Color.black.opacity(0.5)
    
    /// Shadow color
    static let appShadow = Color.black.opacity(0.1)
}

// MARK: - Color Helper

extension Color {
    /// Create a color that adapts to light/dark mode
    /// - Parameters:
    ///   - light: Color for light mode
    ///   - dark: Color for dark mode
    init(light: Color, dark: Color) {
        #if os(iOS)
        self.init(uiColor: UIColor(light: UIColor(light), dark: UIColor(dark)))
        #else
        // macOS fallback - use simple conditional
        self = Color(nsColor: NSColor(name: nil) { appearance in
            if appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua {
                return NSColor(dark)
            } else {
                return NSColor(light)
            }
        } ?? NSColor(light))
        #endif
    }
}

#if os(iOS)
extension UIColor {
    /// Create a UIColor that adapts to light/dark mode
    convenience init(light: UIColor, dark: UIColor) {
        self.init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return dark
            default:
                return light
            }
        }
    }
}
#endif
