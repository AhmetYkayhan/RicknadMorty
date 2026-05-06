import AppLogger
import AppNetwork
import HomeFeature
import SettingsFeatureInterface
import SwiftUI

// MARK: - Settings Feature Assembly

public final class SettingsFeatureAssembly: SettingsFeatureInterface {
    private let networkClient: NetworkClientProtocol
    private let logger: LoggerProtocol
    private let characterDetailFactory: CharacterDetailFactory
    private weak var delegate: SettingsFeatureDelegate?

    public init(networkClient: NetworkClientProtocol,
                logger: LoggerProtocol,
                characterDetailFactory: @escaping CharacterDetailFactory,
                delegate: SettingsFeatureDelegate?)
    {
        self.networkClient = networkClient
        self.logger = logger
        self.characterDetailFactory = characterDetailFactory
        self.delegate = delegate
    }

    // MARK: - Concrete Scene Factory

    @MainActor
    public func makeSettingsScene() -> SettingsView {
        let presenter = SettingsPresenter()
        let interactor = SettingsInteractor(presenter: presenter, delegate: delegate)
        return SettingsView(interactor: interactor, presenter: presenter)
    }

    // MARK: - SettingsFeatureInterface

    @MainActor
    public func makeSettingsView() -> AnyView {
        let searchFactory = makeSearchResultsFactory()
        return AnyView(
            makeSettingsScene()
                .environment(\.searchResultsFactory, searchFactory)
                .environment(\.characterDetailFactory, characterDetailFactory)
        )
    }

    // MARK: - Internal SearchResults factory

    @MainActor
    private func makeSearchResultsFactory() -> SearchResultsFactory {
        let networkClient = networkClient
        let logger = logger
        return { params in
            let service: SearchServiceProtocol = SearchService(networkClient: networkClient)
            let repository: SearchRepositoryProtocol = SearchRepository(service: service, logger: logger)
            let useCase: SearchUseCaseProtocol = SearchUseCase(repository: repository)

            let presenter = SearchResultsPresenter()
            let interactor = SearchResultsInteractor(
                useCase: useCase,
                presenter: presenter,
                params: params
            )
            return AnyView(SearchResultsView(interactor: interactor, presenter: presenter))
        }
    }
}
