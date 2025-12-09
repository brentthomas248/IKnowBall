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

    func loadData() {
        print("DEBUG: HomeViewModel.loadData() called")
        state = .loading
        
        // Load from Service (Always fetch fresh data)
        let user = UserProfileService.shared.userProfile
        
        // Force state update even if already loaded to trigger UI refresh
        if case .loaded(_, let existingGames) = state {
            state = .loaded(user: user, games: existingGames)
        } else {
            let games = [
                GameItem(id: "1", title: "NFL Connection", iconName: "sportscourt.fill"),
                GameItem(id: "3", title: "Ball Knowledge", iconName: "brain.head.profile"),
                GameItem(id: "5", title: "Over / Under", iconName: "arrow.up.arrow.down.square.fill")
            ]
            state = .loaded(user: user, games: games)
        }
    }
}
