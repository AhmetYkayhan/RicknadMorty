import Testing
@testable import ProfileFeature
@testable import HomeFeature

@MainActor
@Suite("FavoriteCharactersInteractor")
struct FavoriteCharactersInteractorTests {

    @Test("onAppear loads from FavoritesStore")
    func onAppear() {
        let store = FavoritesStore()
        let entity = HomeEntity(
            id: 999, name: "Test", status: .alive, species: "Test",
            gender: "Test", origin: "Test", location: "Test", imageURL: nil
        )
        store.toggle(entity)
        defer { store.toggle(entity) } // cleanup

        let presenter = FavoriteCharactersPresenter()
        let sut = FavoriteCharactersInteractor(favoritesStore: store, presenter: presenter)

        sut.handle(.onAppear)
        #expect(presenter.viewState.characters.contains(where: { $0.id == 999 }))
    }
}
