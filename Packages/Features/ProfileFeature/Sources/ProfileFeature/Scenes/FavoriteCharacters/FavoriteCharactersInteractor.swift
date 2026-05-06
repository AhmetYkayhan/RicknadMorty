import Foundation
import HomeFeature

@MainActor
public final class FavoriteCharactersInteractor {
    private let favoritesStore: FavoritesStore
    private let presenter: FavoriteCharactersPresenter

    public init(favoritesStore: FavoritesStore,
                presenter: FavoriteCharactersPresenter) {
        self.favoritesStore = favoritesStore
        self.presenter = presenter
    }

    public func handle(_ request: FavoriteCharacters.Request) {
        switch request {
        case .onAppear, .refresh:
            presenter.present(.loaded(favoritesStore.favorites))
        }
    }
}
