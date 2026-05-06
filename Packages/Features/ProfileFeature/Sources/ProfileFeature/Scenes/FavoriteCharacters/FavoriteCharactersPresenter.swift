import Foundation
import Observation

@MainActor
@Observable
public final class FavoriteCharactersPresenter {
    public private(set) var viewState = FavoriteCharacters.ViewState()

    public init() {}

    public func present(_ response: FavoriteCharacters.Response) {
        switch response {
        case let .loaded(characters):
            viewState.characters = characters
        }
    }
}
