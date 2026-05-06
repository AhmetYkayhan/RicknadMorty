import Foundation
import HomeFeature

@MainActor
public final class ProfileInteractor {
    private let favoritesStore: any FavoritesStoring
    private let presenter: ProfilePresenter

    public init(favoritesStore: any FavoritesStoring,
                presenter: ProfilePresenter)
    {
        self.favoritesStore = favoritesStore
        self.presenter = presenter
    }

    public func handle(_ request: Profile.Request) {
        switch request {
        case .onAppear:
            presenter.present(.countUpdated(favoritesStore.favorites.count))

        case .favoritesTapped:
            presenter.present(.triggerFavoritesNavigation)

        case .consumeNavigationTrigger:
            presenter.present(.clearTrigger)
        }
    }
}
