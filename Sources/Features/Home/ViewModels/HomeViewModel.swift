import SwiftUI

@Observable
final class HomeViewModel {
    enum State {
        case idle
        case loading
        case success
        case error(String)
    }

    var state: State = .idle

    func refresh() {
        state = .loading
        // Simulate network call
        Task {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            state = .success
        }
    }
}
