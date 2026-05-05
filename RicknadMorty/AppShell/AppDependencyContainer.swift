import Foundation
import FirebaseAuth
import AppLogger
import AppStorage
import AppNetwork
import AuthFeatureInterface
import AuthFeature
import HomeFeatureInterface

// MARK: - App Dependency Container

/// Central dependency container. Creates and wires all modules.
/// This is the composition root — the only place that knows about concrete types.
@MainActor
final class AppDependencyContainer {

    // MARK: - Core Dependencies

    private lazy var logger: LoggerProtocol = AppLogger(category: "app")
    private lazy var tokenStorage: TokenStorageProtocol = KeychainTokenStorage()
    private lazy var networkClient: NetworkClientProtocol = NetworkClient(logger: logger)

    // MARK: - Shared Stores

    lazy var favoritesStore: FavoritesStore = FavoritesStore()

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
        let service: HomeServiceProtocol = HomeService(networkClient: networkClient)
        let repository: HomeRepositoryProtocol = HomeRepository(service: service, logger: logger)
        let useCase: GetHomeUseCaseProtocol = GetHomeUseCase(repository: repository)

        return HomeFeatureAssembly(
            getHomeUseCase: useCase,
            delegate: delegate
        )
    }

    // MARK: - Search (Settings)

    func makeSearchViewModel() -> SearchViewModel {
        let service: SearchServiceProtocol = SearchService(networkClient: networkClient)
        let repository: SearchRepositoryProtocol = SearchRepository(service: service, logger: logger)
        let useCase: SearchUseCaseProtocol = SearchUseCase(repository: repository)
        return SearchViewModel(useCase: useCase)
    }

    // MARK: - Helpers

    var isAuthenticated: Bool {
        Auth.auth().currentUser != nil
    }
}
