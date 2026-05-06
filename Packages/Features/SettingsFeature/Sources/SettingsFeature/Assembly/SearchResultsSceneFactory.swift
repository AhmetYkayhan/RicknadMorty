import AppLogger
import AppNetwork
import SwiftUI

// MARK: - SearchResults Scene Factory

//
// Pragmatic NavigationStack bridge — same shape as HomeFeature.CharacterDetailSceneFactory.
// Faz 8'de Environment-based DI'a alınacak.

@MainActor
public final class SearchResultsSceneFactory {
    static var shared: SearchResultsSceneFactory?

    private let networkClient: NetworkClientProtocol
    private let logger: LoggerProtocol

    init(networkClient: NetworkClientProtocol, logger: LoggerProtocol) {
        self.networkClient = networkClient
        self.logger = logger
    }

    static func makeScene(params: Settings.SearchParams) -> SearchResultsView? {
        guard let factory = shared else { return nil }
        let service: SearchServiceProtocol = SearchService(networkClient: factory.networkClient)
        let repository: SearchRepositoryProtocol = SearchRepository(service: service, logger: factory.logger)
        let useCase: SearchUseCaseProtocol = SearchUseCase(repository: repository)

        let presenter = SearchResultsPresenter()
        let interactor = SearchResultsInteractor(
            useCase: useCase,
            presenter: presenter,
            params: params
        )
        return SearchResultsView(interactor: interactor, presenter: presenter)
    }

    static func make(params: Settings.SearchParams) -> AnyView {
        if let scene = makeScene(params: params) {
            return AnyView(scene)
        }
        return AnyView(Text("SearchResults not configured"))
    }
}
