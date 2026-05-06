import AppLogger
import AppNetwork
import AppStorage
import AuthFeature
import AuthFeatureInterface
import Foundation
import HomeFeature
import HomeFeatureInterface
import ProfileFeature
import ProfileFeatureInterface
import SettingsFeature
import SettingsFeatureInterface

// MARK: - App Dependency Container

/// Central dependency container. Creates and wires all modules.
/// This is the composition root — the only place that knows about concrete types.
@MainActor
final class AppDependencyContainer {
    // MARK: - Core Dependencies

    private lazy var logger: LoggerProtocol = AppLogger(category: "app")
    private(set) lazy var tokenStorage: TokenStorageProtocol = KeychainTokenStorage()
    private lazy var networkClient: NetworkClientProtocol = NetworkClient(logger: logger)

    // MARK: - Shared Stores

    lazy var favoritesStore: FavoritesStore = .init()

    // MARK: - Cross-feature factories

    /// Single CharacterDetail factory shared by every tab that needs to
    /// navigate into the detail scene. Built once from the favorites store
    /// and injected into each feature via SwiftUI Environment.
    private lazy var characterDetailFactory: CharacterDetailFactory =
        HomeFeatureAssembly.makeCharacterDetailFactory(favoritesStore: favoritesStore)

    // MARK: - Auth Feature

    func makeAuthFeature(delegate: AuthFeatureDelegate?) -> AuthFeatureInterface {
        AuthFeatureAssembly(
            logger: logger,
            tokenStorage: tokenStorage,
            delegate: delegate
        )
    }

    // MARK: - Home Feature

    func makeHomeFeature(delegate: HomeFeatureDelegate?) -> HomeFeatureInterface {
        HomeFeatureAssembly(
            networkClient: networkClient,
            logger: logger,
            favoritesStore: favoritesStore,
            delegate: delegate
        )
    }

    // MARK: - Profile Feature

    func makeProfileFeature(delegate: ProfileFeatureDelegate?) -> ProfileFeatureInterface {
        ProfileFeatureAssembly(
            favoritesStore: favoritesStore,
            characterDetailFactory: characterDetailFactory,
            delegate: delegate
        )
    }

    // MARK: - Settings Feature

    func makeSettingsFeature(delegate: SettingsFeatureDelegate?) -> SettingsFeatureInterface {
        SettingsFeatureAssembly(
            networkClient: networkClient,
            logger: logger,
            characterDetailFactory: characterDetailFactory,
            delegate: delegate
        )
    }

    // MARK: - Helpers

    /// Token-backed authentication snapshot. Synchronous because callers (AppCoordinator init)
    /// need it during app launch before any async work runs.
    var isAuthenticated: Bool {
        tokenStorage.hasToken
    }
}
