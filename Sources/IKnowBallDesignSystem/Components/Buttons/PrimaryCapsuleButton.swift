import SwiftUI

// MARK: - Primary Capsule Button Component
// Filled capsule button for primary actions with disabled state support

public struct PrimaryCapsuleButton: View {
    let title: String
    let isDisabled: Bool
    let action: () -> Void
    
    public init(_ title: String, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isDisabled = isDisabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .padding(.horizontal, .lg)
                .frame(height: .buttonHeight)
                .frame(maxWidth: .infinity)
                .background(isDisabled ? Color.gray.opacity(0.3) : Color.primary)
                .foregroundStyle(isDisabled ? Color.gray : Color.white)
                .clipShape(Capsule())
        }
        .buttonStyle(PrimaryCapsuleButtonStyle(isDisabled: isDisabled))
        .disabled(isDisabled)
    }
}

// MARK: - Button Style

private struct PrimaryCapsuleButtonStyle: ButtonStyle {
    let isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isDisabled)
    }
}

// MARK: - Previews

// #Preview("Primary Capsule Button") {
//     VStack(spacing: .md) {
//         PrimaryCapsuleButton("Submit") { }
//         PrimaryCapsuleButton("Submit (Disabled)", isDisabled: true) { }
//     }
//     .padding()
// }
