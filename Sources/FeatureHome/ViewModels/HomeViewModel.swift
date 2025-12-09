import SwiftUI
import FeatureGamesShared
import FeatureSettings

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
    
    init(profileService: UserProfileServiceProtocol = UserProfileService.shared) {
        self.profileService = profileService
    }

    func loadData() {
        print("DEBUG: HomeViewModel.loadData() called")
        state = .loading
        
        // Load from Service (Always fetch fresh data)
        let user = profileService.userProfile
        
        Task {
            let games = await GameDataService.shared.loadGameList()
            print("DEBUG: Loaded \(games.count) games")
            await MainActor.run {
                self.state = .loaded(user: user, games: games)
            }
        }
    }
}
