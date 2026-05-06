import Testing
@testable import ProfileFeature

@MainActor
@Suite("ProfilePresenter")
struct ProfilePresenterTests {

    @Test("countUpdated sets count")
    func count() {
        let presenter = ProfilePresenter()
        presenter.present(.countUpdated(3))
        #expect(presenter.viewState.favoriteCount == 3)
    }

    @Test("trigger / clear navigation flag")
    func navigation() {
        let presenter = ProfilePresenter()
        presenter.present(.triggerFavoritesNavigation)
        #expect(presenter.viewState.navigateToFavorites == true)
        presenter.present(.clearTrigger)
        #expect(presenter.viewState.navigateToFavorites == false)
    }
}
