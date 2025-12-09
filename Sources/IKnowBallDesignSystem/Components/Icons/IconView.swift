import SwiftUI

/// Semantic wrapper for SF Symbols with consistent sizing
/// Provides standardized icon sizes following iOS HIG
public struct IconView: View {
    
    // MARK: - Size Presets
    
    public enum IconSize {
        case small      // 16pt - Inline, badges
        case medium     // 20pt - List items, secondary actions
        case large      // 24pt - Primary actions, headers
        case extraLarge // 32pt - Feature highlights
        case hero       // 48pt - Splash screens, empty states
        
        var points: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 20
            case .large: return 24
            case .extraLarge: return 32
            case .hero: return 48
            }
        }
    }
    
    // MARK: - Properties
    
    private let systemName: String
    private let size: IconSize
    private let color: Color?
    private let isCircled: Bool
    
    // MARK: - Initialization
    
    /// Create an icon view
    /// - Parameters:
    ///   - systemName: SF Symbol name
    ///   - size: Icon size preset
    ///   - color: Optional color override (defaults to inherited)
    ///   - isCircled: Whether to show icon in a circle background
    public init(
        _ systemName: String,
        size: IconSize = .medium,
        color: Color? = nil,
        isCircled: Bool = false
    ) {
        self.systemName = systemName
        self.size = size
        self.color = color
        self.isCircled = isCircled
    }
    
    // MARK: - Body
    
    public var body: some View {
        if isCircled {
            circledIcon
        } else {
            plainIcon
        }
    }
    
    @ViewBuilder
    private var plainIcon: some View {
        Image(systemName: systemName)
            .font(.system(size: size.points, weight: .medium))
            .foregroundStyle(color ?? Color.appTextPrimary)
            .frame(width: size.points, height: size.points)
    }
    
    @ViewBuilder
    private var circledIcon: some View {
        ZStack {
            Circle()
                .fill(color ?? Color.appPrimary)
                .opacity(0.15)
                .frame(width: circleSize, height: circleSize)
            
            Image(systemName: systemName)
                .font(.system(size: size.points, weight: .medium))
                .foregroundStyle(color ?? Color.appPrimary)
        }
    }
    
    private var circleSize: CGFloat {
        size.points * 2.5
    }
}

// MARK: - Convenience Initializers

public extension IconView {
    
    /// Create a small icon
    static func small(_ systemName: String, color: Color? = nil) -> IconView {
        IconView(systemName, size: .small, color: color)
    }
    
    /// Create a medium icon
    static func medium(_ systemName: String, color: Color? = nil) -> IconView {
        IconView(systemName, size: .medium, color: color)
    }
    
    /// Create a large icon
    static func large(_ systemName: String, color: Color? = nil) -> IconView {
        IconView(systemName, size: .large, color: color)
    }
    
    /// Create an extra large icon
    static func extraLarge(_ systemName: String, color: Color? = nil) -> IconView {
        IconView(systemName, size: .extraLarge, color: color)
    }
    
    /// Create a hero icon
    static func hero(_ systemName: String, color: Color? = nil) -> IconView {
        IconView(systemName, size: .hero, color: color)
    }
    
    /// Create a circled icon
    static func circled(_ systemName: String, size: IconSize = .medium, color: Color? = nil) -> IconView {
        IconView(systemName, size: size, color: color, isCircled: true)
    }
}

// MARK: - Tappable Icon

/// Icon that responds to tap gestures
public struct TappableIconView: View {
    
    private let systemName: String
    private let size: IconView.IconSize
    private let color: Color?
    private let action: () -> Void
    
    public init(
        _ systemName: String,
        size: IconView.IconSize = .medium,
        color: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.systemName = systemName
        self.size = size
        self.color = color
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            IconView(systemName, size: size, color: color)
                .frame(minWidth: 44, minHeight: 44) // HIG minimum touch target
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

// Note: Previews commented out due to CLI macro plugin issue
// Uncomment when working in Xcode
/*
#if DEBUG
#Preview("Icon Sizes") {
    VStack(spacing: 32) {
        VStack(spacing: 16) {
            Text("Plain Icons")
                .font(.appHeadline)
            
            HStack(spacing: 24) {
                VStack {
                    IconView.small("star.fill")
                    Text("Small")
                        .font(.appCaption)
                }
                
                VStack {
                    IconView.medium("star.fill")
                    Text("Medium")
                        .font(.appCaption)
                }
                
                VStack {
                    IconView.large("star.fill")
                    Text("Large")
                        .font(.appCaption)
                }
                
                VStack {
                    IconView.extraLarge("star.fill")
                    Text("XL")
                        .font(.appCaption)
                }
                
                VStack {
                    IconView.hero("star.fill")
                    Text("Hero")
                        .font(.appCaption)
                }
            }
        }
        
        Divider()
        
        VStack(spacing: 16) {
            Text("Circled Icons")
                .font(.appHeadline)
            
            HStack(spacing: 24) {
                IconView.circled("star.fill", size: .small, color: .appPrimary)
                IconView.circled("heart.fill", size: .medium, color: .appAccent)
                IconView.circled("flame.fill", size: .large, color: .appError)
                IconView.circled("bolt.fill", size: .extraLarge, color: .appWarning)
            }
        }
        
        Divider()
        
        VStack(spacing: 16) {
            Text("Colored Icons")
                .font(.appHeadline)
            
            HStack(spacing: 24) {
                IconView("sportscourt.fill", size: .large, color: .appPrimary)
                IconView("brain.head.profile", size: .large, color: .appSecondary)
                IconView("trophy.fill", size: .large, color: .appAccent)
                IconView("checkmark.circle.fill", size: .large, color: .appSuccess)
            }
        }
        
        Divider()
        
        VStack(spacing: 16) {
            Text("Tappable Icons")
                .font(.appHeadline)
            
            HStack(spacing: 24) {
                TappableIconView("gear", size: .large) {
                    print("Settings tapped")
                }
                
                TappableIconView("questionmark.circle", size: .large) {
                    print("Help tapped")
                }
                
                TappableIconView("xmark", size: .large) {
                    print("Close tapped")
                }
            }
        }
    }
    .padding()
    .background(Color.appBackground)
}
#endif
*/

