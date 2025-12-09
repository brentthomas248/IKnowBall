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
        state = .loading
        
        // Simulate network delay
        Task {
            try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5s
            
            // Success simulation
            let user = UserProfile(
                username: "PlayerOne",
                level: 5,
                currentXP: 450,
                maxXP: 1000
            )
            
            let games = [
                GameItem(id: "1", title: "NFL Connection", iconName: "sportscourt.fill"),
                GameItem(id: "2", title: "Daily Blitz", iconName: "bolt.fill"),
                GameItem(id: "3", title: "Stat Attack", iconName: "chart.bar.fill")
            ]
            
            await MainActor.run {
                state = .loaded(user: user, games: games)
            }
        }
    }
}
