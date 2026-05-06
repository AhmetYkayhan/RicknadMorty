import AppCore
import AppLogger
import AppNetwork
import HomeFeatureInterface
import SwiftUI

// MARK: - Home Feature Assembly

public final class HomeFeatureAssembly: HomeFeatureInterface {
    private let networkClient: NetworkClientProtocol
    private let logger: LoggerProtocol
    private let favoritesStore: FavoritesStore
    private weak var delegate: HomeFeatureDelegate?

    public init(networkClient: NetworkClientProtocol,
                logger: LoggerProtocol,
                favoritesStore: FavoritesStore,
                delegate: HomeFeatureDelegate?)
    {
        self.networkClient = networkClient
        self.logger = logger
        self.favoritesStore = favoritesStore
        self.delegate = delegate
    }

    // MARK: - Concrete Scene Factory

    @MainActor
    public func makeHomeScene() -> HomeListView {
        let service: HomeServiceProtocol = HomeService(networkClient: networkClient)
        let repository: HomeRepositoryProtocol = HomeRepository(service: service, logger: logger)
        let useCase: GetHomeUseCaseProtocol = GetHomeUseCase(repository: repository)

        let presenter = HomeListPresenter()
        let interactor = HomeListInteractor(
            useCase: useCase,
            presenter: presenter,
            delegate: delegate
        )

        CharacterDetailSceneFactory.shared = CharacterDetailSceneFactory(favoritesStore: favoritesStore)

        return HomeListView(interactor: interactor, presenter: presenter)
    }

    // MARK: - HomeFeatureInterface

    @MainActor
    public func makeHomeView() -> AnyView {
        AnyView(makeHomeScene())
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

    public static func makeScene(character: HomeEntity) -> CharacterDetailView? {
        guard let factory = shared else { return nil }
        let presenter = CharacterDetailPresenter()
        let interactor = CharacterDetailInteractor(
            character: character,
            favoritesStore: factory.favoritesStore,
            presenter: presenter
        )
        return CharacterDetailView(interactor: interactor, presenter: presenter)
    }

    public static func make(character: HomeEntity) -> AnyView {
        if let scene = makeScene(character: character) {
            return AnyView(scene)
        }
        return AnyView(Text("CharacterDetail not configured"))
    }
}
