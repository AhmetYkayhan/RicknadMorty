import FirebaseCore
import SwiftUI

@main
struct RicknadMortyApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView(
                coordinator: AppCoordinator(
                    container: AppDependencyContainer()
                )
            )
        }
    }
}
