import SwiftUI

struct ScoreSummaryView: View {
    @State private var viewModel: ScoreSummaryViewModel

    init(score: Int = 0, correctCount: Int = 0, missedCount: Int = 0, xpGained: Int = 450) {
        _viewModel = State(initialValue: ScoreSummaryViewModel(
            score: score,
            correctCount: correctCount,
            missedCount: missedCount,
            xpGained: xpGained
        ))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) { // .lg spacing roughly
                // Header
                Text("TIME'S UP!")
                    .font(.largeTitle)
                    .fontWeight(.heavy)
                    .foregroundColor(.primary)
                    .padding(.top, 32)
                    .accessibilityAddTraits(.isHeader)

                // Score Ring
                ZStack {
                    Circle()
                        .stroke(Color.green.opacity(0.3), lineWidth: 10)
                        .frame(width: 160, height: 160)
                    
                    Circle()
                        .trim(from: 0, to: viewModel.accuracy)
                        .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 160, height: 160)
                        .animation(.easeOut(duration: 1.0), value: viewModel.accuracy)

                    VStack(spacing: 4) {
                        Text(viewModel.accuracyFormatted)
                            .font(.title)
                            .bold()
                            .foregroundColor(.primary)
                        
                        Text(viewModel.scoreFormatted)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 24)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Score ring showing \(viewModel.accuracyFormatted) accuracy and \(viewModel.scoreFormatted)")

                // XP Progress
                VStack(alignment: .leading, spacing: 8) {
                    Text("+\(viewModel.xpGained) XP")
                        .font(.headline)
                        .foregroundColor(.green)
                    
                    ProgressView(value: viewModel.xpProgress)
                        .tint(.green)
                        .scaleEffect(x: 1, y: 2, anchor: .center) // Make it slightly thicker
                        .accessibilityLabel("XP Progress Bar")
                        .accessibilityValue("\(Int(viewModel.xpProgress * 100)) percent")
                    
                    Text("Level 14 Progress...")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 24)

                // Performance Section
                VStack(spacing: 16) {
                    Text("Performance")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: 40) {
                        Label {
                            Text("\(viewModel.correctCount) Correct")
                                .font(.headline)
                        } icon: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green)
                        }
                        
                        Label {
                            Text("\(viewModel.missedCount) Missed")
                                .font(.headline)
                        } icon: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.red)
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Performance: \(viewModel.correctCount) correct, \(viewModel.missedCount) missed")

                    Button(action: {
                        viewModel.reviewAnswers()
                    }) {
                        HStack {
                            Text("Review All Answers & Misses")
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding()
                        .background(Color(uiColor: .systemGray6))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                    }
                    .frame(minHeight: 44)
                    .accessibilityLabel("Review all answers and misses")
                    .accessibilityHint("Double tap to see details of your game")
                }
                .padding(.horizontal, 24)

                Spacer()

                // Bottom Actions
                VStack(spacing: 12) {
                    Button(action: {
                        viewModel.replayLevel()
                    }) {
                        Text("Replay Level")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color(uiColor: .systemGray5))
                            .clipShape(Capsule())
                    }
                    .accessibilityLabel("Replay Level")

                    Button(action: {
                        viewModel.goHome()
                    }) {
                        Text("Back to Home")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.black)
                            .clipShape(Capsule())
                    }
                    .accessibilityLabel("Back to Home")
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 16)
            }
        }
    }
}

#Preview {
    ScoreSummaryView()
}
