import Foundation
import FirebaseAuth

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
        let service: AuthServiceProtocol = FirebaseAuthService()
        let repository: AuthRepositoryProtocol = AuthRepository(service: service, logger: logger)
        let loginUseCase: LoginUseCaseProtocol = LoginUseCase(
            repository: repository,
            tokenStorage: tokenStorage
        )

        return AuthFeatureAssembly(
            loginUseCase: loginUseCase,
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
