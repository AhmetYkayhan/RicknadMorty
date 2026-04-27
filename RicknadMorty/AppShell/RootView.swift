import SwiftUI

// MARK: - Root View

/// The single entry point for the entire app UI.
/// Observes the coordinator and renders the appropriate feature view.
struct RootView: View {
    @State private var coordinator: AppCoordinator

    init(coordinator: AppCoordinator) {
        _coordinator = State(initialValue: coordinator)
    }

    var body: some View {
        coordinator.makeCurrentView()
            .animation(.easeInOut(duration: 0.3), value: coordinator.currentRoute)
    }
}
