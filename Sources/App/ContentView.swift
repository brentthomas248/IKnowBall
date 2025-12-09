import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Text("DEBUG: App is Running")
                .font(.caption)
                .background(Color.yellow)
            
            NavigationStack {
                HomeView()
            }
        }
    }
}

#Preview {
    ContentView()
}
