import Foundation
import Testing
@testable import HomeFeature

@MainActor
@Suite("FavoritesStore")
struct FavoritesStoreTests {
    /// Returns an isolated UserDefaults suite so this test never collides
    /// with the production `favorite_characters` key in `.standard`.
    private static func isolatedDefaults() -> UserDefaults {
        let suiteName = "FavoritesStoreTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }

    private static func sampleEntity(id: Int) -> HomeEntity {
        HomeEntity(
            id: id, name: "Test", status: .alive, species: "Test",
            gender: "Test", origin: "Test", location: "Test", imageURL: nil
        )
    }

    @Test("toggle adds and removes")
    func toggle() {
        let persistence = UserDefaultsFavoritesPersistence(store: Self.isolatedDefaults())
        let store = FavoritesStore(persistence: persistence)
        let entity = Self.sampleEntity(id: 99)

        #expect(store.isFavorite(99) == false)
        store.toggle(entity)
        #expect(store.isFavorite(99) == true)

        store.toggle(entity)
        #expect(store.isFavorite(99) == false)
    }

    @Test("favorites persist across store instances via injected persistence")
    func persistence() {
        let defaults = Self.isolatedDefaults()
        let persistence = UserDefaultsFavoritesPersistence(store: defaults)

        let first = FavoritesStore(persistence: persistence)
        first.toggle(Self.sampleEntity(id: 42))

        let second = FavoritesStore(persistence: UserDefaultsFavoritesPersistence(store: defaults))
        #expect(second.isFavorite(42) == true)
    }
}

@MainActor
@Suite("InMemoryFavoritesStore")
struct InMemoryFavoritesStoreTests {
    @Test("initialFavorites are exposed without persistence")
    func initialFavorites() {
        let entity = HomeEntity(
            id: 7, name: "Test", status: .alive, species: "Test",
            gender: "Test", origin: "Test", location: "Test", imageURL: nil
        )
        let store = InMemoryFavoritesStore(initialFavorites: [entity])
        #expect(store.isFavorite(7) == true)
        store.toggle(entity)
        #expect(store.isFavorite(7) == false)
    }
}
