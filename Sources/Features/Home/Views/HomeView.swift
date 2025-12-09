import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: .lg) {
                switch viewModel.state {
                case .idle, .loading:
                    loadingState
                case .loaded(let user, let games):
                    loadedState(user: user, games: games)
                case .error(let message):
                    errorState(message: message)
                }
            }
            .padding(.horizontal, .md)
            .padding(.top, .lg)
        }
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { /* Navigate to Settings */ }) {
                    Image(systemName: "gearshape")
                        .foregroundColor(.primary)
                }
            }
        }
        .task {
            if case .idle = viewModel.state {
                viewModel.loadData()
            }
        }
    }
    
    // MARK: - Subviews
    
    private var loadingState: some View {
        VStack(spacing: .xl) {
            // Header Skeleton
            HStack(spacing: .md) {
                Circle()
                    .fill(Color.secondary.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                VStack(alignment: .leading, spacing: .xs) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 120, height: 20)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.secondary.opacity(0.1))
                        .frame(width: 80, height: 16)
                }
                Spacer()
            }
            
            // Game Cards Skeleton
            ForEach(0..<3) { _ in
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.secondary.opacity(0.1))
                    .frame(height: 60)
            }
        }
    }
    
    private func loadedState(user: UserProfile, games: [GameItem]) -> some View {
        VStack(spacing: .xl) {
            HStack(spacing: .md) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: .xxs) {
                    Text(user.username)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Level \(user.level)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: .xxs) {
                    Text("XP")
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                    
                    ProgressView(value: user.currentXP, total: user.maxXP)
                        .progressViewStyle(.linear)
                        .frame(width: 80)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Profile: \(user.username), Level \(user.level)")
            
            VStack(spacing: .md) {
                ForEach(games) { game in
                    Button {
                        // Navigate to Game Container
                    } label: {
                        GameCard(game: game)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
    
    private func errorState(message: String) -> some View {
        VStack(spacing: .md) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text("Something went wrong")
                .font(.headline)
            
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                viewModel.loadData()
            }
            .padding(.top, .md)
        }
        .padding(.top, .xxl)
    }
}

private struct GameCard: View {
    let game: GameItem
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .tertiarySystemFill))
            
            HStack(spacing: .md) {
                Image(systemName: game.iconName)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 32)
                
                Text(game.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.body)
                    .foregroundColor(.tertiaryLabel)
            }
            .padding(.horizontal, .md)
        }
        .frame(height: 60)
        .contentShape(Rectangle())
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Play \(game.title)")
        .accessibilityHint("Double tap to start game")
    }
}

private extension Color {
    // Helper for semantic system colors that aren't in standard Color
    static let tertiaryLabel = Color(uiColor: .tertiaryLabel)
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
