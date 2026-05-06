import SwiftUI

// MARK: - Character Detail Factory

/// Closure that produces a CharacterDetail scene for a given `HomeEntity`.
/// Composed at the App shell, injected via SwiftUI Environment so every
/// feature that needs to navigate to CharacterDetail can resolve one
/// without touching global state.
public typealias CharacterDetailFactory = @MainActor (HomeEntity) -> AnyView

// MARK: - Environment Key

private struct CharacterDetailFactoryKey: EnvironmentKey {
    static let defaultValue: CharacterDetailFactory? = nil
}

public extension EnvironmentValues {
    var characterDetailFactory: CharacterDetailFactory? {
        get { self[CharacterDetailFactoryKey.self] }
        set { self[CharacterDetailFactoryKey.self] = newValue }
    }
}
