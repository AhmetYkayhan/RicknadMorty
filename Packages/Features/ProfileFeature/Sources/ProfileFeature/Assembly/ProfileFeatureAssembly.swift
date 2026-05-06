import SwiftUI
import HomeFeature
import ProfileFeatureInterface

public final class ProfileFeatureAssembly: ProfileFeatureInterface {

    private let favoritesStore: FavoritesStore
    private weak var delegate: ProfileFeatureDelegate?

    public init(favoritesStore: FavoritesStore,
                delegate: ProfileFeatureDelegate?) {
        self.favoritesStore = favoritesStore
        self.delegate = delegate
    }

    @MainActor
    public func makeProfileView() -> AnyView {
        FavoriteCharactersSceneFactory.shared = FavoriteCharactersSceneFactory(
            favoritesStore: favoritesStore
        )

        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor(
            favoritesStore: favoritesStore,
            presenter: presenter
        )
        return AnyView(ProfileView(interactor: interactor, presenter: presenter))
    }
}
