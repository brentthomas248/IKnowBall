import SwiftUI

/// A specialized button for binary game choices (True/False, Over/Under, etc.)
public struct GameChoiceButton: View {
    let title: String
    let color: Color
    let isDisabled: Bool
    let action: () -> Void
    
    public init(
        title: String,
        color: Color,
        isDisabled: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.color = color
        self.isDisabled = isDisabled
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.appTitle2)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: .gameButtonHeight)
                .background(color)
                .cornerRadius(.md)
        }
        .disabled(isDisabled)
        .opacity(isDisabled ? 0.6 : 1.0)
    }
}
