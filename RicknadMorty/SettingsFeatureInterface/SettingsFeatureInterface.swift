import SwiftUI

// MARK: - Settings Feature Interface (Stub)

protocol SettingsFeatureInterface {
    @MainActor func makeSettingsView() -> AnyView
}

enum SettingsRoute: Equatable {
    case about
    case privacy
    case logout
}

protocol SettingsFeatureDelegate: AnyObject {
    func settingsFeature(didSelect route: SettingsRoute)
}
