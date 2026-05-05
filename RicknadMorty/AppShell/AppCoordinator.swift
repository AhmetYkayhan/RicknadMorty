import SwiftUI
import Observation
import FirebaseAuth
import AuthFeatureInterface
import HomeFeatureInterface

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
    private var _searchViewModel: SearchViewModel?

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

    @ObservationIgnored
    private var searchViewModel: SearchViewModel {
        if let existing = _searchViewModel { return existing }
        let viewModel = container.makeSearchViewModel()
        _searchViewModel = viewModel
        return viewModel
    }

    init(container: AppDependencyContainer) {
        self.container = container

        // Start on home if already authenticated
        if container.isAuthenticated {
            currentRoute = .home
        }
    }

    // MARK: - Logout

    func logout() {
        try? Auth.auth().signOut()
        _authFeature = nil
        _homeFeature = nil
        _searchViewModel = nil
        withAnimation {
            currentRoute = .login
        }
    }

    // MARK: - View Factory

    @ViewBuilder
    func makeCurrentView() -> some View {
        switch currentRoute {
        case .login:
            authFeature.makeLoginView()
                .transition(.move(edge: .trailing))

        case .home, .characterDetail, .settings, .profile:
            MainTabView(
                homeView: homeFeature.makeHomeView(),
                favoritesStore: container.favoritesStore,
                searchViewModel: searchViewModel,
                onLogout: { [weak self] in self?.logout() }
            )
            .transition(.move(edge: .trailing))
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
