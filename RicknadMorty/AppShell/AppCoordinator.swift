import SwiftUI
import Observation
import FirebaseAuth
import AuthFeatureInterface
import HomeFeature
import HomeFeatureInterface
import ProfileFeature
import ProfileFeatureInterface
import SettingsFeatureInterface

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
    private var _profileFeature: ProfileFeatureInterface?
    private var _settingsFeature: SettingsFeatureInterface?

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
    private var profileFeature: ProfileFeatureInterface {
        if let existing = _profileFeature { return existing }
        let feature = container.makeProfileFeature(delegate: self)
        _profileFeature = feature
        return feature
    }

    @ObservationIgnored
    private var settingsFeature: SettingsFeatureInterface {
        if let existing = _settingsFeature { return existing }
        let feature = container.makeSettingsFeature(delegate: self)
        _settingsFeature = feature
        return feature
    }

    init(container: AppDependencyContainer) {
        self.container = container

        if container.isAuthenticated {
            currentRoute = .home
        }
    }

    // MARK: - Logout

    func logout() {
        try? Auth.auth().signOut()
        _authFeature = nil
        _homeFeature = nil
        _profileFeature = nil
        _settingsFeature = nil
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
                profileView: profileFeature.makeProfileView(),
                settingsView: settingsFeature.makeSettingsView(),
                favoritesStore: container.favoritesStore
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

// MARK: - ProfileFeatureDelegate

extension AppCoordinator: ProfileFeatureDelegate {
    func profileFeature(didSelect route: ProfileRoute) {
        switch route {
        case .editProfile, .logout:
            break
        }
    }
}

// MARK: - SettingsFeatureDelegate

extension AppCoordinator: SettingsFeatureDelegate {
    func settingsFeature(didSelect route: SettingsRoute) {
        switch route {
        case .logout:
            logout()
        case .about, .privacy:
            break
        }
    }
}
