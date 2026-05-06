import SwiftUI
import HomeFeature

@MainActor
public final class FavoriteCharactersSceneFactory {
    static var shared: FavoriteCharactersSceneFactory?

    private let favoritesStore: FavoritesStore

    init(favoritesStore: FavoritesStore) {
        self.favoritesStore = favoritesStore
    }

    static func make() -> AnyView {
        guard let factory = shared else {
            return AnyView(Text("FavoriteCharacters not configured"))
        }
        let presenter = FavoriteCharactersPresenter()
        let interactor = FavoriteCharactersInteractor(
            favoritesStore: factory.favoritesStore,
            presenter: presenter
        )
        return AnyView(FavoriteCharactersView(interactor: interactor, presenter: presenter))
    }
}
