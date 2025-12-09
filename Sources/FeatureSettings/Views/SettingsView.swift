import SwiftUI
import IKnowBallDesignSystem
import IKnowBallCore

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
                            Circle()
                                .fill(Color.appAccent.opacity(0.2))
                                .overlay(
                                    Text(viewModel.user.username.prefix(1).uppercased())
                                        .font(.appTitle2)
                                        .foregroundStyle(Color.appAccent)
                                )
                        }
                        .aspectRatio(contentMode: .fill)
                        .squareFrame(.avatarMedium)
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
                Toggle("Share Analytics", isOn: Binding(
                    get: { AnalyticsService.shared.isEnabled },
                    set: { AnalyticsService.shared.setEnabled($0) }
                ))
            } header: {
                Text("Preferences")
            } footer: {
                Text("Help us improve IKnowBall by sharing anonymous usage data. No personal information is collected.")
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
