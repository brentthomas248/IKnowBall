import SwiftUI

struct OverUnderGameplayView: View {
    @State private var viewModel = OverUnderViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            
            // MARK: - Header
            HStack {
                Text("Over / Under")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Spacer()
                
                HStack(spacing: 16) {
                    // Timer
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text("\(viewModel.timeRemaining)")
                            .monospacedDigit()
                    }
                    .foregroundColor(viewModel.timeRemaining < 10 ? .red : .primary)
                    
                    // Score
                    HStack(spacing: 4) {
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
                VStack(spacing: 8) {
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
            HStack(spacing: 16) {
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
                        .cornerRadius(16)
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
                        .cornerRadius(16)
                }
                .disabled(viewModel.gameState != .playing)
                .opacity(viewModel.gameState != .playing ? 0.6 : 1.0)
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
        .background(Color(uiColor: .systemBackground)) // Clean white as requested (systemBackground adapts)
        .overlay {
            if viewModel.gameState == .gameOver {
                gameOverOverlay
            }
        }
        .onAppear {
            viewModel.startNewGame()
        }
    }
    
    // MARK: - Helpers
    
    private var gameOverOverlay: some View {
        ZStack {
            Color.black.opacity(0.8).ignoresSafeArea()
            
            VStack(spacing: 24) {
                Text("GAME OVER")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                VStack(spacing: 8) {
                    Text("Final Score")
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text("\(viewModel.score)")
                        .font(.system(size: 80, weight: .bold, design: .rounded))
                        .foregroundColor(.yellow)
                }
                
                Button {
                    viewModel.startNewGame()
                } label: {
                    Text("Play Again")
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding(.horizontal, 32)
                        .padding(.vertical, 16)
                        .background(Color.white)
                        .cornerRadius(30)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color(uiColor: .systemGray6))
                    .frame(width: 300)
                    .opacity(0.1) // Subtle backing if needed, or just float on black
            )
        }
    }
    
    // Helper to format 5100.5 -> "5,100.5"
    private func formatValue(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
    }
}

#Preview {
    OverUnderGameplayView()
}
