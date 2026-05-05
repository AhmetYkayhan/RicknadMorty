import SwiftUI
import AppCore
import AppLogger
import AppNetwork
import HomeFeatureInterface

// MARK: - Home Feature Assembly

public final class HomeFeatureAssembly: HomeFeatureInterface {

    private let networkClient: NetworkClientProtocol
    private let logger: LoggerProtocol
    private let favoritesStore: FavoritesStore
    private weak var delegate: HomeFeatureDelegate?

    public init(networkClient: NetworkClientProtocol,
                logger: LoggerProtocol,
                favoritesStore: FavoritesStore,
                delegate: HomeFeatureDelegate?) {
        self.networkClient = networkClient
        self.logger = logger
        self.favoritesStore = favoritesStore
        self.delegate = delegate
    }

    @MainActor
    public func makeHomeView() -> AnyView {
        let service: HomeServiceProtocol = HomeService(networkClient: networkClient)
        let repository: HomeRepositoryProtocol = HomeRepository(service: service, logger: logger)
        let useCase: GetHomeUseCaseProtocol = GetHomeUseCase(repository: repository)

        let presenter = HomeListPresenter()
        let interactor = HomeListInteractor(
            useCase: useCase,
            presenter: presenter,
            delegate: delegate
        )

        // Set up the detail scene factory so HomeListView can create detail screens
        // from NavigationStack's navigationDestination closure.
        CharacterDetailSceneFactory.shared = CharacterDetailSceneFactory(favoritesStore: favoritesStore)

        return AnyView(HomeListView(interactor: interactor, presenter: presenter))
    }
}

// MARK: - Character Detail Scene Factory

@MainActor
public final class CharacterDetailSceneFactory {
    public static var shared: CharacterDetailSceneFactory?

    private let favoritesStore: FavoritesStore

    public init(favoritesStore: FavoritesStore) {
        self.favoritesStore = favoritesStore
    }

    public static func make(character: HomeEntity) -> AnyView {
        guard let factory = shared else {
            return AnyView(Text("CharacterDetail not configured"))
        }
        let presenter = CharacterDetailPresenter()
        let interactor = CharacterDetailInteractor(
            character: character,
            favoritesStore: factory.favoritesStore,
            presenter: presenter
        )
        return AnyView(CharacterDetailView(interactor: interactor, presenter: presenter))
    }
}
