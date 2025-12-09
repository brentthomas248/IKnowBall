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
            // MARK: - Status Header
            HStack(spacing: .md) {
                Text("Mistakes remaining:")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                HStack(spacing: .xs) {
                    ForEach(0..<4) { index in
                        Circle()
                            .fill(index < viewModel.mistakesRemaining ? Color.gray : Color.clear)
                            .frame(width: 12, height: 12)
                            .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                            // Simple visual logic: Filled if remaining, empty if lost
                    }
                }
            }
            .padding(.top, .md)
            
            Spacer()
            
            // MARK: - Game Grid
            LazyVGrid(columns: columns, spacing: .sm) {
                ForEach(viewModel.tiles) { tile in
                    Button {
                        viewModel.toggleSelection(tile)
                    } label: {
                        Text(tile.text)
                            .font(.system(size: 14, weight: .bold)) // Slightly smaller for 4 col
                            .minimumScaleFactor(0.8)
                            .frame(maxWidth: .infinity)
                            .frame(height: 70) // > 60pt min height
                            .background(tile.isSelected ? Color.gray : Color(.systemGray5))
                            .foregroundStyle(tile.isSelected ? .white : .primary)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.black, lineWidth: tile.isSelected ? 0 : 0)
                            )
                    }
                    .buttonStyle(.plain) // Remove default opacity effect
                    .animation(.spring(duration: 0.2), value: tile.isSelected)
                    .accessibilityLabel("\(tile.text)")
                    .accessibilityAddTraits(tile.isSelected ? .isSelected : [])
                    .opacity(tile.isSolved ? 0 : 1) // Visually hide solved tiles
                    .disabled(tile.isSolved)
                }
            }
            
            Spacer()
            
            // MARK: - Action Footer
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
        .padding(.horizontal, .md)
        .navigationTitle("NFL Connection")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
        .navigationDestination(isPresented: $viewModel.showSummary) {
            ScoreSummaryView(
                score: viewModel.score,
                correctCount: viewModel.solvedGroups,
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
}

// MARK: - Custom Button Styles

struct OutlinedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .fontWeight(.semibold)
            .padding(.horizontal, 16)
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
            .padding(.horizontal, 24)
            .frame(height: 44)
            .background(isDisabled ? Color.gray.opacity(0.3) : Color.primary)
            .foregroundStyle(isDisabled ? Color.gray : Color(.systemBackground))
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
