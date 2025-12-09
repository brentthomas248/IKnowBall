import SwiftUI
import FeatureScoreSummary
import FeatureGamesShared
import IKnowBallDesignSystem

public struct ConnectionGameView: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel = ConnectionGameViewModel()

    public init() {}
    
    // Grid Configuration
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    public var body: some View {
        VStack(spacing: .lg) {
            statusHeader
            
            // Solved Groups Section
            if !viewModel.solvedGroups.isEmpty {
                solvedGroupsSection
            }
            
            Spacer()
            
            gameGrid
            
            Spacer()
            
            actionFooter
        }
        .padding(.horizontal, .md)
        .navigationTitle("NFL Connection")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationDestination(isPresented: $viewModel.showSummary) {
            ScoreSummaryView(
                score: viewModel.score,
                correctCount: viewModel.solvedGroupsCount,
                missedCount: viewModel.mistakesMade,
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
    
    // MARK: - Subviews
    
    private var statusHeader: some View {
        HStack(spacing: .md) {
            Text("Mistakes remaining:")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            HStack(spacing: .xs) {
                ForEach(0..<4) { index in
                    Circle()
                        .fill(index < viewModel.mistakesRemaining ? Color.gray : Color.clear)
                        .frame(width: .sm, height: .sm)
                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                        // Simple visual logic: Filled if remaining, empty if lost
                }
            }
        }
        .padding(.top, .md)
    }
    
    private var gameGrid: some View {
        LazyVGrid(columns: columns, spacing: .sm) {
            ForEach(viewModel.activeTiles) { tile in
                Button {
                    viewModel.toggleSelection(tile)
                } label: {
                    Text(tile.text)
                        .font(.system(size: 14, weight: .bold))
                        .minimumScaleFactor(0.8)
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(tile.isSelected ? Color.gray : Color.gray.opacity(0.2))
                        .foregroundStyle(tile.isSelected ? .white : .primary)
                        .clipShape(RoundedRectangle(cornerRadius: .sm))
                }
                .buttonStyle(.plain)
                .animation(.spring(duration: 0.2), value: tile.isSelected)
                .accessibilityLabel("\(tile.text)")
                .accessibilityAddTraits(tile.isSelected ? .isSelected : [])
            }
        }
    }
    
    private var solvedGroupsSection: some View {
        VStack(spacing: .sm) {
            ForEach(viewModel.solvedGroups) { group in
                VStack(alignment: .leading, spacing: .xxs) {
                    Text(group.category.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: .xs) {
                        ForEach(group.tiles, id: \.self) { tileText in
                            Text(tileText)
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, .sm)
                                .padding(.vertical, .xs)
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .padding(.sm)
                .background(Color.blue.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
        .animation(.spring(), value: viewModel.solvedGroups.count)
    }
    
    private var actionFooter: some View {
        HStack(spacing: .md) {
            Button("Shuffle") {
                withAnimation {
                    viewModel.shuffle()
                }
            }
            .buttonStyle(OutlinedButtonStyle())
            
            Button("Deselect All") {
                viewModel.deselectAll()
            }
            .buttonStyle(OutlinedButtonStyle())
            
            Button("Submit") {
                viewModel.submit()
            }
            .buttonStyle(FilledCapsuleButtonStyle(isDisabled: !viewModel.canSubmit))
            .disabled(!viewModel.canSubmit)
        }
        .padding(.bottom, .lg)
    }
}

// MARK: - Custom Button Styles

struct OutlinedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.horizontal, .md)
            .frame(height: 44)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.primary, lineWidth: 1)
            )
            .foregroundStyle(.primary)
            .opacity(configuration.isPressed ? 0.7 : 1.0)
    }
}

struct FilledCapsuleButtonStyle: ButtonStyle {
    let isDisabled: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .fontWeight(.bold)
            .padding(.horizontal, .lg)
            .frame(height: 44)
            .background(isDisabled ? Color.gray.opacity(0.3) : Color.primary)
            .foregroundStyle(isDisabled ? Color.gray : Color.white)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut, value: isDisabled)
    }
}

// #Preview {
//     NavigationStack {
//         ConnectionGameView()
//     }
// }
