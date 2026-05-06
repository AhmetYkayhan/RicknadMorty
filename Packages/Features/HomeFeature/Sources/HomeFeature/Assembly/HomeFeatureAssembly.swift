import AppCore
import AppLogger
import AppNetwork
import HomeFeatureInterface
import SwiftUI

// MARK: - Home Feature Assembly

public final class HomeFeatureAssembly: HomeFeatureInterface {
    private let networkClient: NetworkClientProtocol
    private let logger: LoggerProtocol
    private let favoritesStore: any FavoritesStoring
    private weak var delegate: HomeFeatureDelegate?

    public init(networkClient: NetworkClientProtocol,
                logger: LoggerProtocol,
                favoritesStore: any FavoritesStoring,
                delegate: HomeFeatureDelegate?)
    {
        self.networkClient = networkClient
        self.logger = logger
        self.favoritesStore = favoritesStore
        self.delegate = delegate
    }

    // MARK: - Public CharacterDetail factory builder

    /// Produces a `CharacterDetailFactory` closure bound to the given
    /// favorites store. The App shell calls this once and injects the
    /// resulting closure into every feature that needs CharacterDetail
    /// navigation (Home, Profile, Settings).
    @MainActor
    public static func makeCharacterDetailFactory(
        favoritesStore: any FavoritesStoring
    ) -> CharacterDetailFactory {
        { character in
            let presenter = CharacterDetailPresenter()
            let interactor = CharacterDetailInteractor(
                character: character,
                favoritesStore: favoritesStore,
                presenter: presenter
            )
            return AnyView(CharacterDetailView(interactor: interactor, presenter: presenter))
        }
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

        return HomeListView(interactor: interactor, presenter: presenter)
    }

    // MARK: - HomeFeatureInterface

    @MainActor
    public func makeHomeView() -> AnyView {
        let detailFactory = Self.makeCharacterDetailFactory(favoritesStore: favoritesStore)
        return AnyView(
            makeHomeScene()
                .environment(\.characterDetailFactory, detailFactory)
        )
    }
}
