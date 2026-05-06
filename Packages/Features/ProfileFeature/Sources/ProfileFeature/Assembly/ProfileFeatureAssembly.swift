import HomeFeature
import ProfileFeatureInterface
import SwiftUI

public final class ProfileFeatureAssembly: ProfileFeatureInterface {
    private let favoritesStore: any FavoritesStoring
    private let characterDetailFactory: CharacterDetailFactory
    private weak var delegate: ProfileFeatureDelegate?

    public init(favoritesStore: any FavoritesStoring,
                characterDetailFactory: @escaping CharacterDetailFactory,
                delegate: ProfileFeatureDelegate?)
    {
        self.favoritesStore = favoritesStore
        self.characterDetailFactory = characterDetailFactory
        self.delegate = delegate
    }

    // MARK: - Concrete Scene Factory

    @MainActor
    public func makeProfileScene() -> ProfileView {
        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor(
            favoritesStore: favoritesStore,
            presenter: presenter
        )
        return ProfileView(interactor: interactor, presenter: presenter)
    }

    // MARK: - ProfileFeatureInterface

    @MainActor
    public func makeProfileView() -> AnyView {
        let favoriteFactory = makeFavoriteCharactersFactory()
        return AnyView(
            makeProfileScene()
                .environment(\.favoriteCharactersFactory, favoriteFactory)
                .environment(\.characterDetailFactory, characterDetailFactory)
        )
    }

    // MARK: - Internal FavoriteCharacters factory

    @MainActor
    private func makeFavoriteCharactersFactory() -> FavoriteCharactersFactory {
        let store = favoritesStore
        return {
            let presenter = FavoriteCharactersPresenter()
            let interactor = FavoriteCharactersInteractor(
                favoritesStore: store,
                presenter: presenter
            )
            return AnyView(FavoriteCharactersView(interactor: interactor, presenter: presenter))
        }
    }
}
