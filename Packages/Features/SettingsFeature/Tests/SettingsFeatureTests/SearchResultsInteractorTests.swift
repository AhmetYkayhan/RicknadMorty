import Testing
@testable import AppCore
@testable import HomeFeature
@testable import SettingsFeature

@MainActor
@Suite("SearchResultsInteractor")
struct SearchResultsInteractorTests {
    final class StubUseCase: SearchUseCaseProtocol {
        var result: Result<[SearchResultEntity], Error>
        var calls: [(SearchType, String)] = []

        init(result: Result<[SearchResultEntity], Error>) {
            self.result = result
        }

        func execute(type: SearchType, query: String) async throws -> [SearchResultEntity] {
            calls.append((type, query))
            switch result {
            case let .success(items): return items
            case let .failure(error): throw error
            }
        }
    }

    @Test("onAppear triggers a single search")
    func onAppearSearches() async {
        let ep = EpisodeEntity(id: 1, name: "Pilot", episode: "S01E01", airDate: "2013")
        let useCase = StubUseCase(result: .success([.episode(ep)]))
        let presenter = SearchResultsPresenter()
        let sut = SearchResultsInteractor(
            useCase: useCase,
            presenter: presenter,
            params: .init(query: "pilot", type: .episode)
        )

        sut.handle(.onAppear)
        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(useCase.calls.count == 1)
        #expect(useCase.calls.first?.0 == .episode)
        #expect(useCase.calls.first?.1 == "pilot")
        #expect(presenter.viewState.results.count == 1)
    }

    @Test("onAppear is no-op when already searched")
    func onAppearNoopAfterFirst() async {
        let useCase = StubUseCase(result: .success([]))
        let presenter = SearchResultsPresenter()
        let sut = SearchResultsInteractor(
            useCase: useCase,
            presenter: presenter,
            params: .init(query: "x", type: .character)
        )

        sut.handle(.onAppear)
        try? await Task.sleep(nanoseconds: 100_000_000)
        sut.handle(.onAppear)
        try? await Task.sleep(nanoseconds: 50_000_000)

        #expect(useCase.calls.count == 1)
    }

    @Test("retry forces another search even after success")
    func retrySearchesAgain() async {
        let useCase = StubUseCase(result: .success([]))
        let presenter = SearchResultsPresenter()
        let sut = SearchResultsInteractor(
            useCase: useCase,
            presenter: presenter,
            params: .init(query: "x", type: .character)
        )

        sut.handle(.onAppear)
        try? await Task.sleep(nanoseconds: 100_000_000)
        sut.handle(.retry)
        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(useCase.calls.count == 2)
    }

    @Test("failure populates errorMessage from AppErrorProtocol")
    func failure() async {
        let useCase = StubUseCase(result: .failure(NetworkError.timeout))
        let presenter = SearchResultsPresenter()
        let sut = SearchResultsInteractor(
            useCase: useCase,
            presenter: presenter,
            params: .init(query: "x", type: .character)
        )

        sut.handle(.onAppear)
        try? await Task.sleep(nanoseconds: 100_000_000)

        #expect(presenter.viewState.errorMessage == NetworkError.timeout.userMessage)
        #expect(presenter.viewState.results.isEmpty)
    }
}
