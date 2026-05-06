import AppCore
import Foundation
import Observation

@MainActor
@Observable
public final class HomeListPresenter {
    public private(set) var viewState = HomeList.ViewState()

    public init() {}

    public func present(_ response: HomeList.Response) {
        switch response {
        case .loadingStarted:
            viewState.isLoading = true
            viewState.errorMessage = nil

        case let .pageLoaded(characters, hasMore, append):
            viewState.isLoading = false
            viewState.hasMorePages = hasMore
            viewState.characters = append
                ? viewState.characters + characters
                : characters

        case let .failed(error):
            viewState.isLoading = false
            viewState.errorMessage = error.userMessage
        }
    }
}
