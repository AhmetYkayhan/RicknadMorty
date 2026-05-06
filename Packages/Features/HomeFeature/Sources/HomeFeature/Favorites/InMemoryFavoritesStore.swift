import Foundation

// MARK: - In-Memory Favorites Store (testing / previews)

/// Minimal `FavoritesStoring` implementation that holds favorites in memory.
/// Use in tests and SwiftUI previews to avoid touching `UserDefaults`.
@MainActor
public final class InMemoryFavoritesStore: FavoritesStoring {
    public private(set) var favorites: [HomeEntity]

    public init(initialFavorites: [HomeEntity] = []) {
        favorites = initialFavorites
    }

    public func isFavorite(_ id: Int) -> Bool {
        favorites.contains { $0.id == id }
    }

    public func toggle(_ character: HomeEntity) {
        if let index = favorites.firstIndex(where: { $0.id == character.id }) {
            favorites.remove(at: index)
        } else {
            favorites.append(character)
        }
    }
}
