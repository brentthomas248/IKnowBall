import SwiftUI

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
        
        // Simulate network delay
        Task {
            print("DEBUG: Simulatiing network delay...")
            try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5s
            
            // Success simulation
            print("DEBUG: Network delay finished. Creating data.")
            let user = UserProfile(
                username: "PlayerOne",
                level: 5,
                currentXP: 450,
                maxXP: 1000
            )
            
            let games = [
                GameItem(id: "1", title: "NFL Connection", iconName: "sportscourt.fill"),
                GameItem(id: "3", title: "Ball Knowledge", iconName: "brain.head.profile"),
                GameItem(id: "5", title: "Over / Under", iconName: "arrow.up.arrow.down.square.fill")
            ]
            
            await MainActor.run {
                state = .loaded(user: user, games: games)
            }
        }
    }
}
