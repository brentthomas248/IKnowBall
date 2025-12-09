import SwiftUI
import FeatureScoreSummary
import FeatureGamesShared
import IKnowBallDesignSystem

public struct BallKnowledgeGameView: View {
    @State private var viewModel = BallKnowledgeViewModel()
    @FocusState private var isInputFocused: Bool
    
    public init() {}
    
    // Grid Setup: 4 columns to fit all items on screen
    private let columns = [
        GridItem(.flexible(), spacing: .xs),
        GridItem(.flexible(), spacing: .xs),
        GridItem(.flexible(), spacing: .xs),
        GridItem(.flexible(), spacing: .xs)
    ]
    
    public var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                
                // MARK: - Layer 1: Main Content
                VStack(spacing: 0) {
                    
                    // Header
                    VStack(spacing: .xs) {
                        Text("Best Single Season (2010s)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        HStack {
                            Label {
                                Text("\(viewModel.timeRemaining)s")
                                    .monospacedDigit()
                            } icon: {
                                Image(systemName: "clock")
                            }
                            .font(.headline)
                            .foregroundColor(viewModel.timeRemaining < 30 ? .red : .primary)
                            
                            Spacer()
                            
                            Label {
                                Text("\(viewModel.score)")
                                    .monospacedDigit()
                            } icon: {
                                Image(systemName: "trophy.fill")
                                    .foregroundColor(.yellow)
                            }
                            .font(.headline)
                        }
                        .padding(.horizontal, .lg)
                        .padding(.bottom, .md)
                    }
                    // Header background removed to rely on system default or parent container
                    
                    // Grid Content
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: .sm) {
                            ForEach(viewModel.tiles) { tile in
                                GameTileView(tile: tile)
                                    // Make accessibility element for VoiceOver to read stats
                                    .accessibilityElement(children: .ignore)
                                    .accessibilityLabel(tile.isRevealed ? "Confirmed: \(tile.playerName)" : "Stat: \(tile.stat), Team: \(tile.teamAbbr)")
                            }
                        }
                        .padding(.horizontal, .md)
                        // Add extra padding at bottom so last items aren't hidden by input bar
                        .padding(.bottom, 80)
                    }
                }
                
                // MARK: - Layer 2: Input Bar
                HStack(spacing: .sm) {
                    TextField("Guess Player...", text: $viewModel.currentInput)
                        .focused($isInputFocused)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never) // Names are often simpler without auto-caps interfering
                        .submitLabel(.go)
                        .onSubmit {
                            viewModel.submitGuess()
                        }
                        .padding(.md)
                        .background(Color.secondary.opacity(0.15))
                        .clipShape(Capsule())
                        .accessibilityLabel("Player Name Input")
                    
                    Button {
                        viewModel.submitGuess()
                    } label: {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 44, height: 44)
                            .foregroundColor(.blue)
                    }
                    .accessibilityLabel("Submit Guess")
                }
                .padding(.horizontal, .md)
                .padding(.bottom, .md) // Additional safe area padding handled by default, but nice to be explicit or check constraints
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea(edges: .bottom)
                        // Add a subtle gradient mask integration if needed, but standard material is good
                )
            }
            .navigationTitle("Ball Knowledge")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isInputFocused = true
            }
            .navigationDestination(isPresented: $viewModel.showSummary) {
                ScoreSummaryView(
                    score: viewModel.score,
                    correctCount: viewModel.correctCount,
                    missedCount: viewModel.missedCount
                )
            }
        }
    }
}

#Preview {
    BallKnowledgeGameView()
}
