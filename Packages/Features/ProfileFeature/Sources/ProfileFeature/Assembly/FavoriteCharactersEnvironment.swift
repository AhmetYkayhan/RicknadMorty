import SwiftUI

// MARK: - Favorite Characters Factory

/// Closure that produces the FavoriteCharacters list scene.
/// Internal to ProfileFeature; consumed by `ProfileView`'s navigation
/// destination via SwiftUI Environment.
typealias FavoriteCharactersFactory = @MainActor () -> AnyView

// MARK: - Environment Key

private struct FavoriteCharactersFactoryKey: EnvironmentKey {
    static let defaultValue: FavoriteCharactersFactory? = nil
}

extension EnvironmentValues {
    var favoriteCharactersFactory: FavoriteCharactersFactory? {
        get { self[FavoriteCharactersFactoryKey.self] }
        set { self[FavoriteCharactersFactoryKey.self] = newValue }
    }
}
