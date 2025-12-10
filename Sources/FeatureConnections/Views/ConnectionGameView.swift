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
            
            Spacer()
            
            // Unified grid - solved groups appear inline
            unifiedGrid
            
            Spacer()
            
            actionFooter
        }
        .padding(.horizontal, .md)
        .navigationTitle("NFL Connections")
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
                .font(.appCallout)
                .foregroundStyle(Color.appTextSecondary)
            
            HStack(spacing: .xs) {
                ForEach(0..<4) { index in
                    Circle()
                        .fill(index < viewModel.mistakesRemaining ? Color.appTextTertiary : Color.clear)
                        .squareFrame(.mistakeIndicator)
                        .overlay(Circle().stroke(Color.appTextTertiary, lineWidth: 1))
                }
            }
        }
        .padding(.top, .md)
    }
    
    // MARK: - Unified Grid (NYT Style)
    
    private var unifiedGrid: some View {
        VStack(spacing: .sm) {
            // Display solved groups as rows
            ForEach(viewModel.solvedGroups) { group in
                solvedGroupRow(group)
                    .transition(.asymmetric(
                        insertion: .scale(scale: 0.8).combined(with: .opacity),
                        removal: .opacity
                    ))
            }
            
            // Display active tiles in grid
            if !viewModel.activeTiles.isEmpty {
                activeTilesGrid
            }
        }
        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: viewModel.solvedGroups.count)
        .animation(.spring(response: 0.6, dampingFraction: 0.7), value: viewModel.activeTiles.count)
    }
    
    // Solved group row - 4 tiles in a row
    private func solvedGroupRow(_ group: SolvedGroup) -> some View {
        VStack(alignment: .leading, spacing: .xxs) {
            Text(group.category.uppercased())
                .font(.appCaptionEmphasized)
                .foregroundColor(Color.appTextSecondary)
                .padding(.leading, .xs)
            
            LazyVGrid(columns: columns, spacing: .xs) {
                ForEach(group.tiles, id: \.self) { tileText in
                    Text(tileText)
                        .font(.appCaption)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: .gameTileHeight)
                        .background(Color.appSuccess)
                        .clipShape(RoundedRectangle(cornerRadius: .sm))
                }
            }
        }
        .padding(.vertical, .xxs)
    }
    
    // Active tiles grid - dynamic rows based on remaining tiles
    private var activeTilesGrid: some View {
        LazyVGrid(columns: columns, spacing: .sm) {
            ForEach(viewModel.activeTiles) { tile in
                tileButton(tile)
            }
        }
    }
    
    // Individual tile button
    private func tileButton(_ tile: GameTile) -> some View {
        Button {
            viewModel.toggleSelection(tile)
        } label: {
            Text(tile.text)
                .font(.appCaption)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .frame(maxWidth: .infinity)
                .frame(height: .gameTileHeight)
                .background(tile.isSelected ? Color.appPrimary : Color.appSurface)
                .foregroundStyle(tile.isSelected ? Color.white : Color.appPrimary)
                .clipShape(RoundedRectangle(cornerRadius: .sm))
                .overlay(
                    RoundedRectangle(cornerRadius: .sm)
                        .stroke(Color.appPrimary, lineWidth: 2)
                )
        }
        .buttonStyle(.plain)
        .animation(.spring(duration: 0.2), value: tile.isSelected)
        .accessibilityLabel("\(tile.text)")
        .accessibilityAddTraits(tile.isSelected ? .isSelected : [])
    }
    
    private var actionFooter: some View {
        HStack(spacing: .md) {
            SecondaryButton("Shuffle") {
                withAnimation {
                    viewModel.shuffle()
                }
            }
            
            SecondaryButton("Deselect") {
                viewModel.deselectAll()
            }
            
            PrimaryCapsuleButton("Submit", isDisabled: !viewModel.canSubmit) {
                viewModel.submit()
            }
        }
        .padding(.bottom, .lg)
    }
}

// #Preview {
//     NavigationStack {
//         ConnectionGameView()
//     }
// }
