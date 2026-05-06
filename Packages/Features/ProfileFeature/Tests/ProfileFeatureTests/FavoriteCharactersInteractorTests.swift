import Testing
@testable import HomeFeature
@testable import ProfileFeature

@MainActor
@Suite("FavoriteCharactersInteractor")
struct FavoriteCharactersInteractorTests {
    @Test("onAppear loads from FavoritesStoring")
    func onAppear() {
        let entity = HomeEntity(
            id: 999, name: "Test", status: .alive, species: "Test",
            gender: "Test", origin: "Test", location: "Test", imageURL: nil
        )
        // No UserDefaults side effect — InMemoryFavoritesStore keeps the
        // suite hermetic.
        let store = InMemoryFavoritesStore(initialFavorites: [entity])

        let presenter = FavoriteCharactersPresenter()
        let sut = FavoriteCharactersInteractor(favoritesStore: store, presenter: presenter)

        sut.handle(.onAppear)
        #expect(presenter.viewState.characters.contains(where: { $0.id == 999 }))
    }
}
