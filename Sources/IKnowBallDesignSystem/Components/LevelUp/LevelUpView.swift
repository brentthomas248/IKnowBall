import SwiftUI
import IKnowBallDesignSystem
import IKnowBallCore

// MARK: - Level-Up Celebration View

public struct LevelUpView: View {
    let level: Int
    @State private var isAnimating = false
    let onDismiss: () -> Void
    
    public init(level: Int, onDismiss: @escaping () -> Void) {
        self.level = level
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        ZStack {
            // Dark overlay
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }
            
            VStack(spacing: .xl) {
                // Star/badge icon with animation
                Image(systemName: "star.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.appWarning, Color.appPrimary],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .scaleEffect(isAnimating ? 1.0 : 0.3)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
                
                // Level text
                VStack(spacing: .xs) {
                    Text("Level \(level)")
                        .font(.appDisplayLarge)
                        .foregroundColor(.white)
                    
                    Text("Unlocked!")
                        .font(.appTitle2)
                        .foregroundColor(Color.appSuccess)
                }
                .opacity(isAnimating ? 1 : 0)
            }
        }
        .onAppear {
            // Haptic burst
            #if os(iOS)
            HapticManager.shared.notification(type: .success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                HapticManager.shared.impact(style: .heavy)
            }
            #endif
            
            // Animate in
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                isAnimating = true
            }
            
            // Auto-dismiss after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                onDismiss()
            }
        }
    }
}

// #Preview {
//     LevelUpView(level: 15) {}
// }
