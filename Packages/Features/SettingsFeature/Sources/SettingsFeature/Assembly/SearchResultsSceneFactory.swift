import SwiftUI
import AppLogger
import AppNetwork

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

    static func make(params: Settings.SearchParams) -> AnyView {
        guard let factory = shared else {
            return AnyView(Text("SearchResults not configured"))
        }
        let service: SearchServiceProtocol = SearchService(networkClient: factory.networkClient)
        let repository: SearchRepositoryProtocol = SearchRepository(service: service, logger: factory.logger)
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
