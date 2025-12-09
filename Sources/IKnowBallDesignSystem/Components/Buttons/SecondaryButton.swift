import SwiftUI

// MARK: - Secondary Button Component
// Outlined button style for secondary actions

public struct SecondaryButton: View {
    let title: String
    let action: () -> Void
    
    public init(_ title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.horizontal, .md)
                .frame(height: .buttonHeight)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(Color.primary, lineWidth: 1)
                )
                .foregroundStyle(.primary)
        }
        .buttonStyle(SecondaryButtonStyle())
    }
}

// MARK: - Button Style

private struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

// MARK: - Previews

// #Preview("Secondary Button") {
//     VStack(spacing: .md) {
//         SecondaryButton("Shuffle") { }
//         SecondaryButton("Deselect All") { }
//     }
//     .padding()
// }
