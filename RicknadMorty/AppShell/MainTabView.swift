import SwiftUI

// MARK: - Main Tab View

struct MainTabView: View {
    let homeView: AnyView
    var onLogout: (() -> Void)?

    var body: some View {
        TabView {
            homeView
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }

            SettingsView(onLogout: onLogout)
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}
