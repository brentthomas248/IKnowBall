import SwiftUI

/// Reusable card container component
/// Provides consistent elevation, corners, and spacing for content
public struct CardView<Content: View>: View {
    
    // MARK: - Style
    
    public enum CardStyle {
        case elevated
        case flat
        case outlined
    }
    
    // MARK: - Properties
    
    private let content: Content
    private let style: CardStyle
    private let padding: CGFloat
    
    // MARK: - Initialization
    
    /// Create a card view
    /// - Parameters:
    ///   - style: Visual style of the card
    ///   - padding: Internal padding (defaults to .md)
    ///   - content: Card content
    public init(
        style: CardStyle = .elevated,
        padding: CGFloat = 16, // .md spacing
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.padding = padding
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        content
            .padding(padding)
            .background(cardBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(cardOverlay)
            .shadow(color: cardShadow, radius: cardShadowRadius, x: 0, y: cardShadowY)
    }
    
    // MARK: - Styling Helpers
    
    @ViewBuilder
    private var cardBackground: some View {
        switch style {
        case .elevated, .flat:
            Color.appSurface
        case .outlined:
            Color.appSurface.opacity(0.5)
        }
    }
    
    @ViewBuilder
    private var cardOverlay: some View {
        if style == .outlined {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.appBorder, lineWidth: 1)
        }
    }
    
    private var cardShadow: Color {
        switch style {
        case .elevated:
            return Color.appShadow
        case .flat, .outlined:
            return Color.clear
        }
    }
    
    private var cardShadowRadius: CGFloat {
        style == .elevated ? 8 : 0
    }
    
    private var cardShadowY: CGFloat {
        style == .elevated ? 4 : 0
    }
}

// MARK: - Convenience Initializers

public extension CardView {
    
    /// Create an elevated card with default padding
    static func elevated(@ViewBuilder content: () -> Content) -> CardView {
        CardView(style: .elevated, content: content)
    }
    
    /// Create a flat card with default padding
    static func flat(@ViewBuilder content: () -> Content) -> CardView {
        CardView(style: .flat, content: content)
    }
    
    /// Create an outlined card with default padding
    static func outlined(@ViewBuilder content: () -> Content) -> CardView {
        CardView(style: .outlined, content: content)
    }
}

// MARK: - Interactive Card

/// Card that responds to user interaction
public struct InteractiveCardView<Content: View>: View {
    
    private let content: Content
    private let action: () -> Void
    private let style: CardView<Content>.CardStyle
    
    @State private var isPressed = false
    
    public init(
        style: CardView<Content>.CardStyle = .elevated,
        action: @escaping () -> Void,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.action = action
        self.content = content()
    }
    
    public var body: some View {
        Button(action: action) {
            CardView(style: style) {
                content
            }
        }
        .buttonStyle(CardButtonStyle())
    }
}

// MARK: - Button Style

private struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
    }
}

// MARK: - Preview

// Note: Previews commented out due to CLI macro plugin issue
// Uncomment when working in Xcode
/*
#if DEBUG
#Preview("Card Styles") {
    VStack(spacing: 24) {
        CardView.elevated {
            VStack(alignment: .leading, spacing: 8) {
                Text("Elevated Card")
                    .font(.appHeadline)
                    .foregroundStyle(Color.appTextPrimary)
                Text("This card has elevation with shadow")
                    .font(.appBody)
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        
        CardView.flat {
            VStack(alignment: .leading, spacing: 8) {
                Text("Flat Card")
                    .font(.appHeadline)
                    .foregroundStyle(Color.appTextPrimary)
                Text("This card has no shadow")
                    .font(.appBody)
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        
        CardView.outlined {
            VStack(alignment: .leading, spacing: 8) {
                Text("Outlined Card")
                    .font(.appHeadline)
                    .foregroundStyle(Color.appTextPrimary)
                Text("This card has a border outline")
                    .font(.appBody)
                    .foregroundStyle(Color.appTextSecondary)
            }
        }
        
        InteractiveCardView(action: {
            print("Card tapped!")
        }) {
            HStack {
                Text("Interactive Card")
                    .font(.appHeadline)
                    .foregroundStyle(Color.appTextPrimary)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.appTextTertiary)
            }
        }
    }
    .padding()
    .background(Color.appBackground)
}
#endif
*/
