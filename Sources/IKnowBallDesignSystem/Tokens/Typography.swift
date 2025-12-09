import SwiftUI

// MARK: - Semantic Typography Tokens
// Production-grade typography system using Dynamic Type
// Following iOS Human Interface Guidelines

public extension Font {
    
    // MARK: - Display Styles (Large Headers)
    
    /// Extra large display text
    /// Usage: Hero text, splash screens
    static let appDisplayLarge: Font = .system(.largeTitle, design: .rounded, weight: .bold)
    
    /// Standard display text
    /// Usage: Main page headers
    static let appDisplay: Font = .system(.largeTitle, design: .rounded, weight: .semibold)
    
    // MARK: - Title Styles
    
    /// Large title
    /// Usage: Section headers, modal titles
    static let appTitle1: Font = .system(.title, design: .rounded, weight: .bold)
    
    /// Medium title
    /// Usage: Card titles, subsection headers
    static let appTitle2: Font = .system(.title2, design: .rounded, weight: .semibold)
    
    /// Small title
    /// Usage: List section headers
    static let appTitle3: Font = .system(.title3, design: .rounded, weight: .semibold)
    
    // MARK: - Headline Styles
    
    /// Primary headline
    /// Usage: Emphasized content, button labels
    static let appHeadline: Font = .system(.headline, design: .rounded, weight: .semibold)
    
    /// Secondary headline
    /// Usage: Less emphasized headlines
    static let appHeadlineSecondary: Font = .system(.headline, design: .rounded, weight: .medium)
    
    // MARK: - Body Styles
    
    /// Primary body text
    /// Usage: Main content, descriptions
    static let appBody: Font = .system(.body, design: .default, weight: .regular)
    
    /// Emphasized body text
    /// Usage: Highlighted content within body
    static let appBodyEmphasized: Font = .system(.body, design: .default, weight: .semibold)
    
    /// Large body text
    /// Usage: Introductory paragraphs
    static let appBodyLarge: Font = .system(.body, design: .default, weight: .regular)
        .weight(.regular)
    
    // MARK: - Callout Styles
    
    /// Callout text
    /// Usage: Secondary content, metadata
    static let appCallout: Font = .system(.callout, design: .default, weight: .regular)
    
    /// Emphasized callout
    /// Usage: Highlighted metadata
    static let appCalloutEmphasized: Font = .system(.callout, design: .default, weight: .semibold)
    
    // MARK: - Caption Styles
    
    /// Primary caption
    /// Usage: Timestamps, labels, helper text
    static let appCaption: Font = .system(.caption, design: .default, weight: .regular)
    
    /// Emphasized caption
    /// Usage: Active states, counts
    static let appCaptionEmphasized: Font = .system(.caption, design: .default, weight: .semibold)
    
    /// Small caption
    /// Usage: Legal text, tertiary information
    static let appCaption2: Font = .system(.caption2, design: .default, weight: .regular)
    
    // MARK: - Specialized Styles
    
    /// Monospaced numbers
    /// Usage: Scores, timers, statistics
    static let appNumberLarge: Font = .system(.largeTitle, design: .rounded, weight: .bold)
        .monospacedDigit()
    
    /// Medium monospaced numbers
    /// Usage: In-game scores
    static let appNumberMedium: Font = .system(.title, design: .rounded, weight: .semibold)
        .monospacedDigit()
    
    /// Small monospaced numbers
    /// Usage: Counters, badges
    static let appNumberSmall: Font = .system(.body, design: .rounded, weight: .medium)
        .monospacedDigit()
    
    /// Button text
    /// Usage: All button labels
    static let appButton: Font = .system(.body, design: .rounded, weight: .semibold)
    
    /// Tab bar text
    /// Usage: Tab bar labels
    static let appTab: Font = .system(.caption, design: .default, weight: .medium)
}

// MARK: - Text Modifiers

public extension View {
    
    /// Apply primary text style
    /// - Returns: View with text styling
    func textStylePrimary() -> some View {
        self
            .font(.appBody)
            .foregroundStyle(Color.appTextPrimary)
    }
    
    /// Apply secondary text style
    /// - Returns: View with text styling
    func textStyleSecondary() -> some View {
        self
            .font(.appCallout)
            .foregroundStyle(Color.appTextSecondary)
    }
    
    /// Apply tertiary text style
    /// - Returns: View with text styling
    func textStyleTertiary() -> some View {
        self
            .font(.appCaption)
            .foregroundStyle(Color.appTextTertiary)
    }
    
    /// Apply headline style
    /// - Returns: View with text styling
    func textStyleHeadline() -> some View {
        self
            .font(.appHeadline)
            .foregroundStyle(Color.appTextPrimary)
    }
    
    /// Apply title style
    /// - Parameter level: Title level (1, 2, or 3)
    /// - Returns: View with text styling
    func textStyleTitle(_ level: Int = 1) -> some View {
        self
            .font(level == 1 ? .appTitle1 : level == 2 ? .appTitle2 : .appTitle3)
            .foregroundStyle(Color.appTextPrimary)
    }
}

// MARK: - Line Height & Letter Spacing

public extension View {
    
    /// Apply standard line height for body text
    /// - Returns: View with line spacing
    func bodyLineSpacing() -> some View {
        self.lineSpacing(4)
    }
    
    /// Apply tight line height for headlines
    /// - Returns: View with line spacing
    func headlineLineSpacing() -> some View {
        self.lineSpacing(2)
    }
    
    /// Apply wide tracking for emphasis
    /// - Returns: View with tracking
    func wideTracking() -> some View {
        self.tracking(0.5)
    }
    
    /// Apply tight tracking for condensed text
    /// - Returns: View with tracking
    func tightTracking() -> some View {
        self.tracking(-0.5)
    }
}
