import Foundation
import SwiftUI
import Observation

// MARK: - Favorites Store Environment Key

private struct FavoritesStoreKey: EnvironmentKey {
    static let defaultValue: FavoritesStore? = nil
}

public extension EnvironmentValues {
    var favoritesStore: FavoritesStore? {
        get { self[FavoritesStoreKey.self] }
        set { self[FavoritesStoreKey.self] = newValue }
    }
}

// MARK: - Favorites Store

@MainActor
@Observable
public final class FavoritesStore {
    private static let key = "favorite_characters"

    public private(set) var favorites: [HomeEntity] = []

    public init() {
        load()
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
        save()
    }

    // MARK: - Persistence

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: Self.key),
              let decoded = try? JSONDecoder().decode([HomeEntity].self, from: data) else {
            return
        }
        favorites = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(favorites) else { return }
        UserDefaults.standard.set(data, forKey: Self.key)
    }
}
