import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(minHeight: 50)
                .background(Color.blue)
                .cornerRadius(12)
        }
        .contentShape(Rectangle()) // Ensures 44pt+ touch area is respected even if visual is smaller (though here it's 50)
    }
}

#Preview {
    PrimaryButton(title: "Sign In") {
        print("Tapped")
    }
    .padding()
}
