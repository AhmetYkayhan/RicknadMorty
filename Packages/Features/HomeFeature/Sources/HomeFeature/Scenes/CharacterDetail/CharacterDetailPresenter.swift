import Foundation
import Observation

@MainActor
@Observable
public final class CharacterDetailPresenter {
    public private(set) var viewState = CharacterDetail.ViewState()

    public init() {}

    public func present(_ response: CharacterDetail.Response) {
        switch response {
        case let .loaded(character, isFavorite):
            viewState.character = character
            viewState.isFavorite = isFavorite

        case let .favoriteChanged(isFavorite):
            viewState.isFavorite = isFavorite
        }
    }
}
