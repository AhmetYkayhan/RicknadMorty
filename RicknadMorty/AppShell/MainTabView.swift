import HomeFeature
import SwiftUI

// MARK: - Main Tab View

struct MainTabView: View {
    let homeView: AnyView
    let profileView: AnyView
    let settingsView: AnyView
    let favoritesStore: FavoritesStore

    var body: some View {
        TabView {
            homeView
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            profileView
                .tabItem {
                    Label("Profile", systemImage: "person")
                }

            settingsView
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
        .environment(\.favoritesStore, favoritesStore)
    }
}
