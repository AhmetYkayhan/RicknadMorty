import Foundation
import Observation
import AppCore

@MainActor
@Observable
public final class SearchResultsPresenter {
    public private(set) var viewState = SearchResults.ViewState()

    public init() {}

    public func present(_ response: SearchResults.Response) {
        switch response {
        case .loadingStarted:
            viewState.isLoading = true
            viewState.errorMessage = nil
            viewState.hasSearched = true
        case let .loaded(items):
            viewState.isLoading = false
            viewState.results = items
        case let .failed(error):
            viewState.isLoading = false
            viewState.results = []
            viewState.errorMessage = error.userMessage
        }
    }
}
