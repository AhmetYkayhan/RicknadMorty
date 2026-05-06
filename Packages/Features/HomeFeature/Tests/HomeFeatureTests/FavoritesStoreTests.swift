import Testing
@testable import HomeFeature

@MainActor
@Suite("FavoritesStore")
struct FavoritesStoreTests {
    @Test("toggle adds and removes")
    func toggle() {
        let store = FavoritesStore()
        let entity = HomeEntity(
            id: 99, name: "Test", status: .alive, species: "Test",
            gender: "Test", origin: "Test", location: "Test", imageURL: nil
        )

        let initial = store.isFavorite(99)
        store.toggle(entity)
        #expect(store.isFavorite(99) == !initial)

        store.toggle(entity)
        #expect(store.isFavorite(99) == initial)
    }
}
