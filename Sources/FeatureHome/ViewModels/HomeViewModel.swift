import SwiftUI
import FeatureGamesShared
import FeatureSettings
import IKnowBallCore
import OSLog

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
    private let logger = Logger(subsystem: "com.iknowball", category: "HomeViewModel")
    
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
        logger.debug("loadData() called")
        state = .loading
        
        // Track screen view
        analyticsService.logScreenView("home")
        
        // Load from Service (Always fetch fresh data)
        let user = profileService.userProfile
        
        Task {
            do {
                let games = try await gameDataService.loadGameList()
                logger.info("Loaded \(games.count) games")
                
                // TESTING: Delay to show skeleton loader
                try? await Task.sleep(for: .seconds(2))
                
                await MainActor.run {
                    self.state = .loaded(user: user, games: games)
                }
            } catch {
                // Handle error
                await MainActor.run {
                    self.state = .error(error.localizedDescription)
                    logger.error("Failed to load games: \(error.localizedDescription)")
                }
            }
        }
    }
}
