import SwiftUI

// MARK: - Settings Feature Interface (Stub)

public protocol SettingsFeatureInterface {
    @MainActor func makeSettingsView() -> AnyView
}

public enum SettingsRoute: Equatable {
    case about
    case privacy
    case logout
}

public protocol SettingsFeatureDelegate: AnyObject {
    func settingsFeature(didSelect route: SettingsRoute)
}
