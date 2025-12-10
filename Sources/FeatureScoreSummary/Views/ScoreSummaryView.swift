import SwiftUI
import IKnowBallCore
import IKnowBallDesignSystem
import FeatureSettings

public struct ScoreSummaryView: View {
    @State private var viewModel: ScoreSummaryViewModel
    @State private var showLevelUp = false
    @State private var newLevel: Int?

    public init(
        score: Int = 0,
        correctCount: Int = 0,
        missedCount: Int = 0,
        metrics: XPCalculator.GameMetrics? = nil,
        onReplay: @escaping () -> Void = {},
        onHome: @escaping () -> Void = {}
    ) {
        let vm = ScoreSummaryViewModel(
            score: score,
            correctCount: correctCount,
            missedCount: missedCount,
            metrics: metrics,
            shouldAwardXP: true  // Explicitly award XP when shown
        )
        vm.onReplayLevel = onReplay
        vm.onGoHome = onHome
        _viewModel = State(initialValue: vm)
    }

    public var body: some View {
        ZStack {
            // Main content (scrollable to prevent level-up from hiding buttons)
            ScrollView {
                VStack(spacing: 24) { // .lg spacing roughly
                // Header
                Text("TIME'S UP!")
                    .font(.appDisplayLarge)
                    .foregroundColor(Color.appTextPrimary)
                    .padding(.top, .xl)
                    .accessibilityAddTraits(.isHeader)

                // Score Ring
                ZStack {
                    Circle()
                        .stroke(Color.appSuccess.opacity(0.3), lineWidth: 10)
                        .squareFrame(.scoreSummaryIcon)
                    
                    Circle()
                        .trim(from: 0, to: viewModel.accuracy)
                        .stroke(Color.appSuccess, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 160, height: 160)
                        .animation(.easeOut(duration: 1.0), value: viewModel.accuracy)

                    VStack(spacing: .xxs) {
                        Text(viewModel.accuracyFormatted)
                            .font(.appTitle1)
                            .foregroundColor(Color.appTextPrimary)
                        
                        Text(viewModel.scoreFormatted)
                            .font(.appHeadline)
                            .foregroundColor(Color.appTextSecondary)
                    }
                }
                .padding(.vertical, .lg)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Score ring showing \(viewModel.accuracyFormatted) accuracy and \(viewModel.scoreFormatted)")

                // XP Breakdown Section
                VStack(alignment: .leading, spacing: .xs) {
                    Text("XP Earned")
                        .font(.appHeadline)
                        .foregroundColor(Color.appTextPrimary)
                    
                    Divider()
                        .background(Color.appTextTertiary)
                    
                    // Breakdown items with staggered animation
                    ForEach(Array(viewModel.xpBreakdownItems.enumerated()), id: \.offset) { index, item in
                        HStack {
                            Text(item.0)
                                .font(.appBody)
                                .foregroundColor(Color.appTextSecondary)
                            Spacer()
                            Text("+\(item.1) XP")
                                .font(.appBodyEmphasized)
                                .foregroundColor(Color.appSuccess)
                        }
                        .opacity(1.0)
                    }
                    
                    // Total separator
                    Rectangle()
                        .fill(Color.appPrimary)
                        .frame(height: 2)
                        .padding(.vertical, .xxs)
                    
                    // Total XP
                    HStack {
                        Text("Total")
                            .font(.appHeadline)
                            .foregroundColor(Color.appTextPrimary)
                        Spacer()
                        HStack(spacing: .xxs) {
                            Text("+\(viewModel.xpGained)")
                                .font(.appTitle2)
                                .foregroundColor(Color.appSuccess)
                            Text("XP")
                                .font(.appHeadline)
                                .foregroundColor(Color.appSuccess)
                            Image(systemName: "sparkles")
                                .foregroundColor(Color.appWarning)
                        }
                    }
                    
                    // Progress bar below total
                    VStack(alignment: .leading, spacing: .xxs) {
                        ProgressView(value: viewModel.xpProgress)
                            .tint(Color.appSuccess)
                            .scaleEffect(x: 1, y: 2, anchor: .center)
                        
                        Text("Level Progress")
                            .font(.appCaption)
                            .foregroundColor(Color.appTextSecondary)
                    }
                    .padding(.top, .xs)
                }
                .padding(.md)
                .background(Color.appSurface)
                .clipShape(RoundedRectangle(cornerRadius: .md))
                .padding(.horizontal, .lg)

                // Performance Section
                VStack(spacing: .md) {
                    Text("Performance")
                        .font(.appCallout)
                        .foregroundColor(Color.appTextSecondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack(spacing: .xl) {
                        Label {
                            Text("\(viewModel.correctCount) Correct")
                                .font(.appHeadline)
                        } icon: {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(Color.appSuccess)
                        }
                        
                        Label {
                            Text("\(viewModel.missedCount) Missed")
                                .font(.appHeadline)
                        } icon: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color.appError)
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel("Performance: \(viewModel.correctCount) correct, \(viewModel.missedCount) missed")

                    Button(action: {
                        viewModel.reviewAnswers()
                    }) {
                        HStack {
                            Text("Review All Answers & Misses")
                                .font(.appBody)
                            Spacer()
                            Image(systemName: "chevron.right")
                        }
                        .padding(.md)
                        .background(Color.appSurface)
                        .foregroundColor(Color.appTextPrimary)
                        .cornerRadius(.md)
                    }
                    .frame(minHeight: .minimumTouchTarget)
                    .accessibilityLabel("Review all answers and misses")
                    .accessibilityHint("Double tap to see details of your game")
                }
                .padding(.horizontal, .lg)

                Spacer()

                // Bottom Actions
                VStack(spacing: .sm) {
                    Button(action: {
                        viewModel.replayLevel()
                    }) {
                        Text("Replay Level")
                            .font(.appHeadline)
                            .foregroundColor(Color.appTextPrimary)
                            .frame(maxWidth: .infinity)
                            .frame(height: .buttonHeightCompact)
                            .background(Color.appSurface)
                            .clipShape(Capsule())
                    }
                    .accessibilityLabel("Replay Level")

                    Button(action: {
                        viewModel.goHome()
                    }) {
                        Text("Back to Home")
                            .font(.appHeadline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: .buttonHeightCompact)
                            .background(Color.appPrimary)
                            .clipShape(Capsule())
                    }
                    .accessibilityLabel("Back to Home")
                }
                .padding(.horizontal, .lg)
                .padding(.bottom, .md)
            } // End VStack
            } // End ScrollView
            .scrollDisabled(showLevelUp)  // Disable scrolling when level-up is shown
            
            // Level-up celebration overlay
            if showLevelUp, let level = newLevel {
                LevelUpView(level: level) {
                    showLevelUp = false
                }
            }
        }
        .onAppear {
            // Listen for level-up events
            UserProfileService.shared.onLevelUp = { level in
                newLevel = level
                showLevelUp = true
            }
        }
    }
}

// #Preview {
//     ScoreSummaryView()
// }
