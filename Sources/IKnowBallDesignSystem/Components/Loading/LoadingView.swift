import SwiftUI

/// Reusable loading indicator component
/// Displays a progress spinner with optional label text
public struct LoadingView: View {
    
    // MARK: - Properties
    
    private let label: String?
    private let tintColor: Color
    
    // MARK: - Initialization
    
    /// Create a loading view
    /// - Parameters:
    ///   - label: Optional text to display below the spinner
    ///   - tintColor: Color for the progress view (defaults to .appPrimary)
    public init(label: String? = nil, tintColor: Color = .appPrimary) {
        self.label = label
        self.tintColor = tintColor
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: .md) {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(tintColor)
                .scaleEffect(1.2)
            
            if let label = label {
                Text(label)
                    .font(.appCallout)
                    .foregroundStyle(Color.appTextSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(label ?? "Loading")
    }
}

// MARK: - Convenience Initializers

public extension LoadingView {
    
    /// Create a loading view with primary color
    static func primary(label: String? = nil) -> LoadingView {
        LoadingView(label: label, tintColor: .appPrimary)
    }
    
    /// Create a loading view with secondary color
    static func secondary(label: String? = nil) -> LoadingView {
        LoadingView(label: label, tintColor: .appSecondary)
    }
    
    /// Create a loading view with accent color
    static func accent(label: String? = nil) -> LoadingView {
        LoadingView(label: label, tintColor: .appAccent)
    }
}

// MARK: - Overlay Modifier

public extension View {
    
    /// Show a loading overlay when isLoading is true
    /// - Parameters:
    ///   - isLoading: Whether to show the loading overlay
    ///   - label: Optional label text
    /// - Returns: View with loading overlay
    func loadingOverlay(isLoading: Bool, label: String? = nil) -> some View {
        self.overlay {
            if isLoading {
                LoadingView(label: label)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.appBackground.opacity(0.8))
                    .transition(.opacity)
            }
        }
    }
}

// MARK: - Preview

// Note: Previews commented out due to CLI macro plugin issue
// Uncomment when working in Xcode
/*
#if DEBUG
#Preview("Loading States") {
    VStack(spacing: 32) {
        LoadingView()
        
        LoadingView(label: "Loading games...")
        
        LoadingView.primary(label: "Fetching data...")
        
        LoadingView.secondary(label: "Please wait...")
        
        LoadingView.accent(label: "Loading...")
    }
    .padding()
    .background(Color.appBackground)
}

#Preview("Loading Overlay") {
    CardView.elevated {
        VStack {
            Text("Content behind loading overlay")
                .font(.appHeadline)
            
            Text("This demonstrates the loading overlay")
                .font(.appBody)
        }
    }
    .padding()
    .frame(height: 300)
    .loadingOverlay(isLoading: true, label: "Loading...")
}
#endif
*/
