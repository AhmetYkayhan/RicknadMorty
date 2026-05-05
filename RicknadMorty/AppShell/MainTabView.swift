import SwiftUI
import HomeFeature

// MARK: - Main Tab View

struct MainTabView: View {
    let homeView: AnyView
    let favoritesStore: FavoritesStore
    let searchViewModel: SearchViewModel
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

            SettingsView(
                viewModel: searchViewModel,
                onLogout: onLogout
            )
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
        }
        .environment(\.favoritesStore, favoritesStore)
    }
}
