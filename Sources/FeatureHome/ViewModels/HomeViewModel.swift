import SwiftUI
import FeatureGamesShared
import FeatureSettings
import IKnowBallCore

@Observable
final class HomeViewModel {
    enum State {
        case idle
        case loading
        case loaded(user: UserProfile, games: [GameItem])
        case error(String)
    }

    var state: State = .idle
    private let profileService: UserProfileServiceProtocol
    private let gameDataService: GameDataServiceProtocol
    private let analyticsService: AnalyticsServiceProtocol
    
    init(
        profileService: UserProfileServiceProtocol = UserProfileService.shared,
        gameDataService: GameDataServiceProtocol = GameDataService.shared,
        analyticsService: AnalyticsServiceProtocol = AnalyticsService.shared
    ) {
        self.profileService = profileService
        self.gameDataService = gameDataService
        self.analyticsService = analyticsService
    }

    func loadData() {
        print("DEBUG: HomeViewModel.loadData() called")
        state = .loading
        
        // Track screen view
        analyticsService.logScreenView("home")
        
        // Load from Service (Always fetch fresh data)
        let user = profileService.userProfile
        
        Task {
            do {
                let games = try await gameDataService.loadGameList()
                print("DEBUG: Loaded \\(games.count) games")
                await MainActor.run {
                    self.state = .loaded(user: user, games: games)
                }
            } catch {
                // Handle error
                await MainActor.run {
                    self.state = .error(error.localizedDescription)
                    print("ERROR: Failed to load games: \\(error.localizedDescription)")
                }
            }
        }
    }
}
