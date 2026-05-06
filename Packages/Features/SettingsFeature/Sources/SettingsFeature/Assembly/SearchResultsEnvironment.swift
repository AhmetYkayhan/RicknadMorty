import SwiftUI

// MARK: - Search Results Factory

/// Closure that produces a SearchResults scene for the given parameters.
/// Internal to SettingsFeature; consumed by `SettingsView`'s
/// navigation destination via SwiftUI Environment.
typealias SearchResultsFactory = @MainActor (Settings.SearchParams) -> AnyView

// MARK: - Environment Key

private struct SearchResultsFactoryKey: EnvironmentKey {
    static let defaultValue: SearchResultsFactory? = nil
}

extension EnvironmentValues {
    var searchResultsFactory: SearchResultsFactory? {
        get { self[SearchResultsFactoryKey.self] }
        set { self[SearchResultsFactoryKey.self] = newValue }
    }
}
