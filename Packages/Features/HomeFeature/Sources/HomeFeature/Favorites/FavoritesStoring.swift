import Foundation

// MARK: - Favorites Storing Protocol

/// Read/write contract for the favorites collection.
///
/// Use this protocol in interactors and other non-observing consumers to keep
/// them decoupled from the concrete `FavoritesStore` (and its UserDefaults
/// persistence). SwiftUI views that need observation should keep the
/// concrete `FavoritesStore` type via `@Environment(\.favoritesStore)`.
@MainActor
public protocol FavoritesStoring: AnyObject {
    var favorites: [HomeEntity] { get }
    func isFavorite(_ id: Int) -> Bool
    func toggle(_ character: HomeEntity)
}
