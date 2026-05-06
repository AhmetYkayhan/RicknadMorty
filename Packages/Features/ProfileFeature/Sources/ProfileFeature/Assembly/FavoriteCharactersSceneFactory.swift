import HomeFeature
import SwiftUI

@MainActor
public final class FavoriteCharactersSceneFactory {
    static var shared: FavoriteCharactersSceneFactory?

    private let favoritesStore: FavoritesStore

    init(favoritesStore: FavoritesStore) {
        self.favoritesStore = favoritesStore
    }

    static func makeScene() -> FavoriteCharactersView? {
        guard let factory = shared else { return nil }
        let presenter = FavoriteCharactersPresenter()
        let interactor = FavoriteCharactersInteractor(
            favoritesStore: factory.favoritesStore,
            presenter: presenter
        )
        return FavoriteCharactersView(interactor: interactor, presenter: presenter)
    }

    static func make() -> AnyView {
        if let scene = makeScene() {
            return AnyView(scene)
        }
        return AnyView(Text("FavoriteCharacters not configured"))
    }
}
