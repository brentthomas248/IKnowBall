import SwiftUI
import IKnowBallCore

/// Reusable error state view
/// Displays user-friendly error messages with optional retry action
public struct ErrorView: View {
    
    // MARK: - Properties
    
    private let error: UserFacingError
    private let style: ErrorStyle
    
    public enum ErrorStyle {
        case fullScreen  // For major errors (empty state replacement)
        case inline      // For minor errors (in-place display)
    }
    
    // MARK: - Initialization
    
    public init(error: UserFacingError, style: ErrorStyle = .inline) {
        self.error = error
        self.style = style
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: style == .fullScreen ? 24 : 16) {
            // Icon
            IconView(
                error.icon,
                size: style == .fullScreen ? .hero : .extraLarge,
                color: .appError
            )
            
            // Error Text
            VStack(spacing: 8) {
                Text(error.title)
                    .font(style == .fullScreen ? .appTitle2 : .appHeadline)
                    .foregroundStyle(Color.appTextPrimary)
                    .multilineTextAlignment(.center)
                
                Text(error.message)
                    .font(style == .fullScreen ? .appBody : .appCallout)
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
            }
            
            // Retry Button
            if error.canRetry, let retryAction = error.retryAction {
                Button(action: retryAction) {
                    HStack(spacing: 8) {
                        Image(systemName: "arrow.clockwise")
                        Text("Try Again")
                    }
                    .font(.appButton)
                    .foregroundStyle(Color.appTextOnPrimary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.appPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: style == .fullScreen ? .infinity : 400)
        .padding(style == .fullScreen ? 32 : 16)
    }
}

// MARK: - Convenience Initializers

public extension ErrorView {
    
    /// Create a full-screen error view
    static func fullScreen(_ error: UserFacingError) -> ErrorView {
        ErrorView(error: error, style: .fullScreen)
    }
    
    /// Create an inline error view
    static func inline(_ error: UserFacingError) -> ErrorView {
        ErrorView(error: error, style: .inline)
    }
}

// MARK: - View Modifier

public extension View {
    
    /// Show an error overlay when error is present
    /// - Parameter error: Optional error to display
    /// - Returns: View with error overlay
    func errorOverlay(_ error: UserFacingError?) -> some View {
        self.overlay {
            if let error = error {
                ErrorView.fullScreen(error)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.appBackground.opacity(0.95))
                    .transition(.opacity)
            }
        }
    }
}
