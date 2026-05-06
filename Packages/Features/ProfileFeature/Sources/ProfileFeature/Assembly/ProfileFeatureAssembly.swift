import HomeFeature
import ProfileFeatureInterface
import SwiftUI

public final class ProfileFeatureAssembly: ProfileFeatureInterface {
    private let favoritesStore: FavoritesStore
    private weak var delegate: ProfileFeatureDelegate?

    public init(favoritesStore: FavoritesStore,
                delegate: ProfileFeatureDelegate?)
    {
        self.favoritesStore = favoritesStore
        self.delegate = delegate
    }

    // MARK: - Concrete Scene Factory

    @MainActor
    public func makeProfileScene() -> ProfileView {
        FavoriteCharactersSceneFactory.shared = FavoriteCharactersSceneFactory(
            favoritesStore: favoritesStore
        )

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
        AnyView(makeProfileScene())
    }
}
