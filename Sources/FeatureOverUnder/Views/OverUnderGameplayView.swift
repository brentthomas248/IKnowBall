import SwiftUI
import FeatureScoreSummary
import IKnowBallDesignSystem

public struct OverUnderGameplayView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = OverUnderViewModel()

    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Header
            HStack {
                Text("Over / Under")
                    .font(.appHeadline)
                
                Spacer()
                
                HStack(spacing: .md) {
                    // Timer
                    HStack(spacing: .xxs) {
                        Image(systemName: "clock")
                        Text("\(viewModel.timeRemaining)")
                            .monospacedDigit()
                    }
                    .foregroundColor(viewModel.timeRemaining < 10 ? Color.appError : Color.appTextPrimary)
                    
                    // Score
                    HStack(spacing: .xxs) {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(Color.appWarning)
                        Text("\(viewModel.score)")
                            .monospacedDigit()
                    }
                }
                .font(.appHeadline)
            }
            .padding(.md)
            
            Spacer()
            
            // MARK: - Game Content
            if let question = viewModel.currentQuestion {
                VStack(spacing: .xs) {
                    Text(question.player)
                        .font(.appTitle3)
                        .foregroundStyle(Color.appTextPrimary)
                        .multilineTextAlignment(.center)
                    
                    Text("\(question.statContext) • \(question.team)")
                        .font(.appCallout)
                        .foregroundColor(Color.appTextSecondary)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: .spacerLarge)
                    
                    // The Line / Result
                    if viewModel.gameState == .showingResult {
                        // Show Actual Value with Color
                        Text(formatValue(question.actualValue))
                            .font(.system(size: 60, weight: .black, design: .rounded))
                            .foregroundColor(viewModel.lastGuessWasCorrect == true ? Color.appSuccess : Color.appError)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        // Show Line Value
                        Text(formatValue(question.lineValue))
                            .font(.system(size: 60, weight: .black, design: .rounded))
                            .foregroundColor(Color.appTextPrimary)
                    }
                }
                .padding(.horizontal, .md)
                .animation(.spring(bounce: 0.3), value: viewModel.gameState)
            }
            
            Spacer()
            
            // MARK: - Controls
            HStack(spacing: .md) {
                // UNDER Button
                Button {
                    viewModel.submitGuess(isOver: false)
                } label: {
                    Text("UNDER")
                        .font(.appTitle2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: .gameButtonHeight)
                        .background(Color.appError)
                        .cornerRadius(.md)
                }
                .disabled(viewModel.gameState != .playing)
                .opacity(viewModel.gameState != .playing ? 0.6 : 1.0)
                
                // OVER Button
                Button {
                    viewModel.submitGuess(isOver: true)
                } label: {
                    Text("OVER")
                        .font(.appTitle2)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: .gameButtonHeight)
                        .background(Color.appSuccess)
                        .cornerRadius(.md)
                }
                .disabled(viewModel.gameState != .playing)
                .opacity(viewModel.gameState != .playing ? 0.6 : 1.0)
            }
            .padding(.horizontal, .md)
            .padding(.bottom, .xl)
        }
        .background(Color.appBackground)
        .navigationDestination(isPresented: $viewModel.showSummary) {
            ScoreSummaryView(
                score: viewModel.score,
                correctCount: viewModel.correctCount,
                missedCount: viewModel.missedCount,
                onReplay: {
                    viewModel.showSummary = false
                    viewModel.startNewGame()
                },
                onHome: {
                    viewModel.showSummary = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        dismiss()
                    }
                }
            )
        }
    }
    
    // MARK: - Helpers
    
    // Helper to format 5100.5 -> "5,100.5"
    private func formatValue(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

// #Preview {
//     OverUnderGameplayView()
// }
