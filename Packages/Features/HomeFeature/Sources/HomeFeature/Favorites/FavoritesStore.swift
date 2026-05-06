import Foundation
import Observation
import SwiftUI

// MARK: - Favorites Store Environment Key

private struct FavoritesStoreKey: EnvironmentKey {
    static let defaultValue: FavoritesStore? = nil
}

public extension EnvironmentValues {
    /// SwiftUI views consume the concrete `FavoritesStore` to participate
    /// in observation tracking. Non-observing consumers (interactors, etc.)
    /// should depend on `any FavoritesStoring` directly.
    var favoritesStore: FavoritesStore? {
        get { self[FavoritesStoreKey.self] }
        set { self[FavoritesStoreKey.self] = newValue }
    }
}

// MARK: - Favorites Store

@MainActor
@Observable
public final class FavoritesStore: FavoritesStoring {
    public private(set) var favorites: [HomeEntity] = []

    @ObservationIgnored private let persistence: FavoritesPersistence

    public init(persistence: FavoritesPersistence = UserDefaultsFavoritesPersistence()) {
        self.persistence = persistence
        favorites = persistence.load()
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
        persistence.save(favorites)
    }
}
