import Testing
@testable import AppCore
@testable import SettingsFeature

@MainActor
@Suite("SearchResultsPresenter")
struct SearchResultsPresenterTests {
    @Test("loadingStarted sets loading and marks hasSearched")
    func loadingStarted() {
        let presenter = SearchResultsPresenter()
        presenter.present(.loadingStarted)

        #expect(presenter.viewState.isLoading == true)
        #expect(presenter.viewState.hasSearched == true)
        #expect(presenter.viewState.errorMessage == nil)
    }

    @Test("loaded sets results and clears loading")
    func loaded() {
        let presenter = SearchResultsPresenter()
        presenter.present(.loadingStarted)
        let ep = EpisodeEntity(id: 1, name: "Pilot", episode: "S01E01", airDate: "2013")
        presenter.present(.loaded([.episode(ep)]))

        #expect(presenter.viewState.results.count == 1)
        #expect(presenter.viewState.isLoading == false)
    }

    @Test("failed sets error message and clears results")
    func failed() {
        let presenter = SearchResultsPresenter()
        presenter.present(.loadingStarted)
        presenter.present(.failed(error: NetworkError.timeout))

        #expect(presenter.viewState.isLoading == false)
        #expect(presenter.viewState.results.isEmpty)
        #expect(presenter.viewState.errorMessage == NetworkError.timeout.userMessage)
    }
}
