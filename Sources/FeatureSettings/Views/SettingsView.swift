import SwiftUI

public struct SettingsView: View {
    @State private var viewModel = SettingsViewModel()

    public init() {}
    
    public var body: some View {
        List {
            // Section 1: Account
            Section {
                NavigationLink(destination: Text("Edit Profile")) { // Placeholder destination
                    HStack(spacing: 12) {
                        AsyncImage(url: viewModel.user.avatarURL) { image in
                            image.resizable()
                        } placeholder: {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .foregroundStyle(.gray)
                        }
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                        
                        Text(viewModel.user.username)
                            .font(.headline)
                    }
                }
            } header: {
                Text("Account")
            }
            
            // Section 2: Preferences
            Section {
                Toggle("Sound Effects", isOn: $viewModel.isSoundEnabled)
                Toggle("Haptic Feedback", isOn: $viewModel.isHapticsEnabled)
                Toggle("Daily Reminders", isOn: $viewModel.isDailyReminderEnabled)
            } header: {
                Text("Preferences")
            }
            
            // Section 3: Support
            Section {
                NavigationLink(destination: Text("Help & Feedback")) { // Placeholder destination
                    Label("Help & Feedback", systemImage: "questionmark.circle")
                }
            } header: {
                Text("Support")
            }
        }

        #if os(iOS)
        .listStyle(.insetGrouped)
        #else
        .listStyle(.sidebar)
        #endif
        .navigationTitle("Settings")
    }
}

// #Preview {
//     SettingsView()
// }
