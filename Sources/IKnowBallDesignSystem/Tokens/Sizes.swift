import SwiftUI

// MARK: - Semantic Size Tokens
// Production-grade sizing system for consistent UI dimensions
// Following iOS Human Interface Guidelines

public extension CGFloat {
    
    // MARK: - Touch Targets
    
    /// Minimum touch target size per iOS HIG (44x44 pt)
    static let minimumTouchTarget: CGFloat = 44
    
    /// Recommended touch target for primary actions (48x48 pt)
    static let touchTargetLarge: CGFloat = 48
    
    // MARK: - Icon Sizes
    
    /// Small icon size (16pt) - For inline icons
    static let iconSmall: CGFloat = 16
    
    /// Medium icon size (24pt) - For toolbar icons
    static let iconMedium: CGFloat = 24
    
    /// Large icon size (32pt) - For prominent UI elements
    static let iconLarge: CGFloat = 32
    
    /// Extra large icon size (48pt) - For feature icons
    static let iconXLarge: CGFloat = 48
    
    // MARK: - Avatar Sizes
    
    /// Small avatar (32x32 pt)
    static let avatarSmall: CGFloat = 32
    
    /// Medium avatar (40x40 pt)
    static let avatarMedium: CGFloat = 40
    
    /// Large avatar (60x60 pt)
    static let avatarLarge: CGFloat = 60
    
    /// Extra large avatar (80x80 pt)
    static let avatarXLarge: CGFloat = 80
    
    // MARK: - Common Component Heights
    
    /// Standard button height
    static let buttonHeight: CGFloat = 44
    
    /// Large button height
    static let buttonHeightLarge: CGFloat = 52
    
    /// Text field height
    static let textFieldHeight: CGFloat = 44
    
    /// Search bar height
    static let searchBarHeight: CGFloat = 36
    
    /// Progress bar height (thin)
    static let progressBarThin: CGFloat = 4
    
    /// Progress bar height (medium)
    static let progressBarMedium: CGFloat = 8
    
    /// Compact button height (50pt) - For secondary actions
    static let buttonHeightCompact: CGFloat = 50
    
    /// Game button height (80pt) - For Over/Under game buttons
    static let gameButtonHeight: CGFloat = 80
    
    /// Large spacer height (40pt) - For vertical spacing in game views
    static let spacerLarge: CGFloat = 40
    
    // MARK: - Card & Container Sizes
    
    /// Minimum card height
    static let cardMinHeight: CGFloat = 80
    
    /// Standard card height
    static let cardStandardHeight: CGFloat = 120
    
    /// Game tile height (for grid layouts)
    static let gameTileHeight: CGFloat = 70
    
    // MARK: - Feature-Specific Sizes
    
    /// Score summary icon size (160x160 pt)
    static let scoreSummaryIcon: CGFloat = 160
    
    /// Skeleton loader heights
    static let skeletonSmall: CGFloat = 16
    static let skeletonMedium: CGFloat = 18
    static let skeletonLarge: CGFloat = 20
    
    /// Mistake indicator size (connections game)
    static let mistakeIndicator: CGFloat = 12
}

// MARK: - Size Helper Extension

public extension View {
    /// Apply a square frame with the given size
    /// - Parameter size: The width and height for the square frame
    func squareFrame(_ size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }
}
