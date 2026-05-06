import Foundation
import Observation

@MainActor
@Observable
public final class ProfilePresenter {
    public private(set) var viewState = Profile.ViewState()

    public init() {}

    public func present(_ response: Profile.Response) {
        switch response {
        case let .countUpdated(count):
            viewState.favoriteCount = count
        case .triggerFavoritesNavigation:
            viewState.navigateToFavorites = true
        case .clearTrigger:
            viewState.navigateToFavorites = false
        }
    }
}
