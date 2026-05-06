import Foundation

@MainActor
public final class CharacterDetailInteractor {
    private let character: HomeEntity
    private let favoritesStore: FavoritesStore
    private let presenter: CharacterDetailPresenter

    public init(character: HomeEntity,
                favoritesStore: FavoritesStore,
                presenter: CharacterDetailPresenter)
    {
        self.character = character
        self.favoritesStore = favoritesStore
        self.presenter = presenter
    }

    public func handle(_ request: CharacterDetail.Request) {
        switch request {
        case .onAppear:
            presenter.present(.loaded(
                character: character,
                isFavorite: favoritesStore.isFavorite(character.id)
            ))

        case .toggleFavorite:
            favoritesStore.toggle(character)
            presenter.present(.favoriteChanged(
                isFavorite: favoritesStore.isFavorite(character.id)
            ))
        }
    }
}
