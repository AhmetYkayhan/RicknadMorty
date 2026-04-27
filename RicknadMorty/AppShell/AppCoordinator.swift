import SwiftUI
import Observation

// MARK: - App Coordinator

/// Manages top-level navigation and acts as the delegate for all feature modules.
/// Feature modules never import each other — the coordinator routes between them.
@MainActor
@Observable
final class AppCoordinator {
    var currentRoute: AppRoute = .login

    private let container: AppDependencyContainer
    private var _authFeature: AuthFeatureInterface?
    private var _homeFeature: HomeFeatureInterface?

    @ObservationIgnored
    private var authFeature: AuthFeatureInterface {
        if let existing = _authFeature { return existing }
        let feature = container.makeAuthFeature(delegate: self)
        _authFeature = feature
        return feature
    }

    @ObservationIgnored
    private var homeFeature: HomeFeatureInterface {
        if let existing = _homeFeature { return existing }
        let feature = container.makeHomeFeature(delegate: self)
        _homeFeature = feature
        return feature
    }

    init(container: AppDependencyContainer) {
        self.container = container

        // Start on home if already authenticated
        if container.isAuthenticated {
            currentRoute = .home
        }
    }

    // MARK: - View Factory

    @ViewBuilder
    func makeCurrentView() -> some View {
        switch currentRoute {
        case .login:
            authFeature.makeLoginView()
                .transition(.move(edge: .trailing))

        case .home:
            homeFeature.makeHomeView()
                .transition(.move(edge: .trailing))

        case .characterDetail(let id):
            // Placeholder — would be a CharacterDetailFeature
            Text("Character Detail: \(id)")
                .font(.title)

        case .settings:
            // Placeholder — would be SettingsFeature
            Text("Settings")
                .font(.title)

        case .profile:
            // Placeholder — would be ProfileFeature
            Text("Profile")
                .font(.title)
        }
    }
}

// MARK: - AuthFeatureDelegate

extension AppCoordinator: AuthFeatureDelegate {
    func authFeature(didComplete route: AuthRoute) {
        switch route {
        case .loginCompleted:
            withAnimation {
                currentRoute = .home
            }
        case .forgotPassword:
            break
        case .register:
            break
        }
    }
}

// MARK: - HomeFeatureDelegate

extension AppCoordinator: HomeFeatureDelegate {
    func homeFeature(didSelect route: HomeRoute) {
        switch route {
        case .characterDetail(let id):
            withAnimation {
                currentRoute = .characterDetail(id: id)
            }
        case .settings:
            withAnimation {
                currentRoute = .settings
            }
        case .profile:
            withAnimation {
                currentRoute = .profile
            }
        }
    }
}
