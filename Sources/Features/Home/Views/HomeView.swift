import SwiftUI

struct HomeView: View {
    @State private var viewModel = HomeViewModel()

    var body: some View {
        VStack(spacing: .lg) {
            Image(systemName: "figure.basketball")
                .font(.system(size: 60))
                .foregroundColor(.blue)

            Text("IKnowBall")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Welcome to the ultimate basketball knowledge app.")
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)

            Spacer()
                .frame(height: .xl)

            PrimaryButton(title: "Get Started") {
                viewModel.refresh()
            }
        }
        .padding(.md)
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
