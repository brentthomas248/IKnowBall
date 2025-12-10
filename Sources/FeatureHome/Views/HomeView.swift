import SwiftUI
import FeatureSettings
import FeatureBallKnowledge
import FeatureOverUnder
import FeatureConnections
import FeatureGamesShared
import IKnowBallDesignSystem
import IKnowBallCore

public struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    public init() {}

    public var body: some View {
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
        .background(Color.appBackground)
        .navigationTitle("Home")
        .task {
            viewModel.loadData()
        }
        .onAppear {
            // Refresh to pick up XP reset
            viewModel.loadData()
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                // TESTING: Manual XP Reset Button
                Button("Reset XP") {
                    UserProfileService.shared.resetXP()
                    viewModel.loadData()  // Refresh UI
                }
                .foregroundColor(.red)
            }
            
            ToolbarItem(placement: .primaryAction) {
                NavigationLink(destination: SettingsView()) {
                    IconView("gearshape", size: .medium, color: .appTextPrimary)
                }
            }
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    // MARK: - Loading State
    
    private var loadingState: some View {
        VStack(spacing: .xl) {
            // User Stats Skeleton - Matches actual UserStatsCard layout
            CardView.elevated {
                VStack(spacing: .md) {
                    HStack(spacing: .md) {
                        // Avatar placeholder (matches IconView.circled)
                        Circle()
                            .fill(Color.appSurface.opacity(0.3))
                            .squareFrame(.avatarLarge)
                        
                        // User Info placeholder
                        VStack(alignment: .leading, spacing: .xxs) {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.appSurface.opacity(0.3))
                                .frame(width: 120, height: .skeletonLarge)
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.appSurface.opacity(0.3))
                                .frame(width: 80, height: .skeletonSmall)
                        }
                        
                        Spacer()
                        
                        // XP Display placeholder
                        VStack(alignment: .trailing, spacing: .xxs) {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.appSurface.opacity(0.3))
                                .frame(width: 40, height: .skeletonMedium)
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.appSurface.opacity(0.3))
                                .frame(width: 25, height: .skeletonSmall)
                        }
                    }
                    
                    // Progress Bar Section placeholder
                    VStack(alignment: .leading, spacing: .xxs) {
                        // Progress label
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(Color.appSurface.opacity(0.3))
                            .frame(width: 150, height: .skeletonSmall)
                        
                        // Progress bar
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(Color.appSurface.opacity(0.3))
                            .frame(height: .progressBarMedium)
                    }
                }
            }
            .redacted(reason: .placeholder)
            
            // Game Cards Skeleton
            ForEach(0..<3) { _ in
                CardView.elevated {
                    HStack(spacing: .md) {
                        // Game icon placeholder (matches IconView size)
                        Circle()
                            .fill(Color.appSurface.opacity(0.3))
                            .squareFrame(.iconXLarge)
                        
                        VStack(alignment: .leading, spacing: .xxs) {
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.appSurface.opacity(0.3))
                                .frame(width: 150, height: .skeletonMedium)
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.appSurface.opacity(0.3))
                                .frame(width: 80, height: .skeletonSmall)
                        }
                        Spacer()
                    }
                }
                .redacted(reason: .placeholder)
            }
        }
    }

    
    // MARK: - Loaded State
    
    private func loadedState(user: UserProfile, games: [GameItem]) -> some View {
        VStack(spacing: .xl) {
            // Premium User Stats Card
            userStatsCard(user: user)
            
            // Game List
            VStack(spacing: .md) {
                ForEach(games) { game in
                    gameCard(for: game)
                }
            }
        }
    }
    
    // MARK: - User Stats Card
    
    private func userStatsCard(user: UserProfile) -> some View {
        CardView.elevated {
            VStack(spacing: .md) {
                HStack(spacing: .md) {
                    // Avatar
                    IconView.circled("person.fill", size: .large, color: .appPrimary)
                    
                    // User Info
                    VStack(alignment: .leading, spacing: .xxs) {
                        Text(user.username)
                            .font(.appTitle2)
                            .foregroundStyle(Color.appTextPrimary)
                        
                        Text("Level \(user.level)")
                            .font(.appCallout)
                            .foregroundStyle(Color.appTextSecondary)
                    }
                    
                    Spacer()
                    
                    // XP Display
                    VStack(alignment: .trailing, spacing: .xxs) {
                        Text("\(Int(user.currentXP))")
                            .font(.appNumberMedium)
                            .foregroundStyle(Color.appPrimary)
                        
                        Text("XP")
                            .font(.appCaption)
                            .foregroundStyle(Color.appTextSecondary)
                    }
                }
                
                // Progress Bar with Gradient
                VStack(alignment: .leading, spacing: .xxs) {
                    HStack {
                        Text("Progress to Level \(user.level + 1)")
                            .font(.appCaption)
                            .foregroundStyle(Color.appTextSecondary)
                        Spacer()
                        Text("\(Int(user.currentXP))/\(Int(user.maxXP))")
                            .font(.appCaptionEmphasized)
                            .foregroundStyle(Color.appTextPrimary)
                    }
                    
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color.appSurface.opacity(0.5))
                            
                            // Progress Fill with Gradient
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.appPrimary, Color.appAccent]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * CGFloat(user.currentXP / user.maxXP))
                        }
                    }
                    .frame(height: .progressBarMedium)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Profile: \(user.username), Level \(user.level), \(Int(user.currentXP)) XP out of \(Int(user.maxXP))")
    }
    
    // MARK: - Game Card
    
    private func gameCard(for game: GameItem) -> some View {
        NavigationLink {
            destinationView(for: game)
        } label: {
            CardView.elevated {
                HStack(spacing: .md) {
                    // Game Icon
                    IconView(game.iconName, size: .extraLarge, color: .appPrimary)
                    
                    // Game Info
                    VStack(alignment: .leading, spacing: .xxs) {
                        Text(game.title)
                            .font(.appHeadline)
                            .foregroundStyle(Color.appTextPrimary)
                        
                        Text("Tap to play")
                            .font(.appCaption)
                            .foregroundStyle(Color.appTextSecondary)
                    }
                    
                    Spacer()
                    
                    // Chevron
                    IconView("chevron.right", size: .medium, color: .appTextTertiary)
                }
            }
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            TapGesture().onEnded {
                #if os(iOS)
                HapticManager.shared.impact(style: .light)
                #endif
            }
        )
        .accessibilityLabel("Play \(game.title)")
        .accessibilityHint("Double tap to start game")
    }
    
    // MARK: - Error State
    
    private func errorState(message: String) -> some View {
        ErrorView.fullScreen(
            UserFacingError(
                title: "Cannot Load Games",
                message: message,
                icon: "exclamationmark.triangle.fill",
                canRetry: true,
                retryAction: {
                    viewModel.loadData()
                }
            )
        )
    }
    
    // MARK: - Helper Methods
    
    @ViewBuilder
    private func destinationView(for game: GameItem) -> some View {
        if game.title == "Ball Knowledge" {
            BallKnowledgeGameView()
        } else if game.title == "Over / Under" {
            OverUnderGameplayView()
        } else {
            ConnectionGameView()
        }
    }
}

// #Preview {
//     NavigationStack {
//         HomeView()
//     }
// }
