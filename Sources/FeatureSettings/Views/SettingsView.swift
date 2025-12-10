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
                NavigationLink(destination: Text("Edit Profile")) {
                    HStack(spacing: .md) {
                        IconView.circled("person.fill", size: .large, color: .appPrimary)
                        
                        Text(viewModel.user.username)
                            .font(.appHeadline)
                            .foregroundStyle(Color.appTextPrimary)
                    }
                    .padding(.vertical, .xxs)
                }
            } header: {
                Text("Account")
            }
            
            // Section 2: Preferences
            Section {
                HStack {
                    Label("Sound Effects", systemImage: "speaker.wave.2")
                        .font(.appBody)
                    Spacer()
                    Toggle("", isOn: $viewModel.isSoundEnabled)
                        .labelsHidden()
                }
                
                HStack {
                    Label("Haptic Feedback", systemImage: "iphone.radiowaves.left.and.right")
                        .font(.appBody)
                    Spacer()
                    Toggle("", isOn: $viewModel.isHapticsEnabled)
                        .labelsHidden()
                }
                
                HStack {
                    Label("Daily Reminders", systemImage: "bell")
                        .font(.appBody)
                    Spacer()
                    Toggle("", isOn: $viewModel.isDailyReminderEnabled)
                        .labelsHidden()
                }
                
                HStack {
                    Label("Share Analytics", systemImage: "chart.bar")
                        .font(.appBody)
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { AnalyticsService.shared.isEnabled },
                        set: { AnalyticsService.shared.setEnabled($0) }
                    ))
                    .labelsHidden()
                }
            } header: {
                Text("Preferences")
            } footer: {
                Text("Help us improve IKnowBall by sharing anonymous usage data. No personal information is collected.")
                    .font(.appCaption)
                    .foregroundColor(Color.appTextSecondary)
            }
            
            // Section 3: Support
            Section {
                NavigationLink(destination: Text("Help & Feedback")) {
                    Label {
                        Text("Help & Feedback")
                            .font(.appBody)
                    } icon: {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(Color.appPrimary)
                    }
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
