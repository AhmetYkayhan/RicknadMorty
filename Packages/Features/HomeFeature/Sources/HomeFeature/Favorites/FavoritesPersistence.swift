import Foundation

// MARK: - Favorites Persistence Protocol

/// Side-effect interface for loading and saving the favorites list.
/// Injected into `FavoritesStore` so tests can swap UserDefaults for a stub.
public protocol FavoritesPersistence {
    func load() -> [HomeEntity]
    func save(_ items: [HomeEntity])
}

// MARK: - UserDefaults Implementation

public final class UserDefaultsFavoritesPersistence: FavoritesPersistence {
    private let key: String
    private let store: UserDefaults

    public init(store: UserDefaults = .standard, key: String = "favorite_characters") {
        self.store = store
        self.key = key
    }

    public func load() -> [HomeEntity] {
        guard let data = store.data(forKey: key),
              let decoded = try? JSONDecoder().decode([HomeEntity].self, from: data)
        else {
            return []
        }
        return decoded
    }

    public func save(_ items: [HomeEntity]) {
        guard let data = try? JSONEncoder().encode(items) else { return }
        store.set(data, forKey: key)
    }
}
