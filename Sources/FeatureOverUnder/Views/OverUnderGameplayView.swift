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
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: .md) {
                    // Timer
                    HStack(spacing: .xxs) {
                        Image(systemName: "clock")
                        Text("\(viewModel.timeRemaining)")
                            .monospacedDigit()
                    }
                    .foregroundColor(viewModel.timeRemaining < 10 ? .red : .primary)
                    
                    // Score
                    HStack(spacing: .xxs) {
                        Image(systemName: "trophy.fill")
                            .foregroundColor(.yellow)
                        Text("\(viewModel.score)")
                            .monospacedDigit()
                    }
                }
                .font(.headline)
            }
            .padding()
            
            Spacer()
            
            // MARK: - Game Content
            if let question = viewModel.currentQuestion {
                VStack(spacing: .xs) {
                    Text(question.player)
                        .font(.title3)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                    
                    Text("\(question.statContext) • \(question.team)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    Spacer().frame(height: 40)
                    
                    // The Line / Result
                    if viewModel.gameState == .showingResult {
                        // Show Actual Value with Color
                        Text(formatValue(question.actualValue))
                            .font(.system(size: 60, weight: .black, design: .rounded))
                            .foregroundColor(viewModel.lastGuessWasCorrect == true ? .green : .red)
                            .transition(.scale.combined(with: .opacity))
                    } else {
                        // Show Line Value
                        Text(formatValue(question.lineValue))
                            .font(.system(size: 60, weight: .black, design: .rounded))
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
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
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background(Color.red)
                        .cornerRadius(.md)
                }
                .disabled(viewModel.gameState != .playing)
                .opacity(viewModel.gameState != .playing ? 0.6 : 1.0)
                
                // OVER Button
                Button {
                    viewModel.submitGuess(isOver: true)
                } label: {
                    Text("OVER")
                        .font(.title2)
                        .fontWeight(.heavy)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 80)
                        .background(Color.green)
                        .cornerRadius(.md)
                }
                .disabled(viewModel.gameState != .playing)
                .opacity(viewModel.gameState != .playing ? 0.6 : 1.0)
            }
            .padding(.horizontal)
            .padding(.bottom, .xl)
        }
        .background(Color.white)
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
