import SwiftUI

// MARK: - Profile Feature Interface (Stub)

protocol ProfileFeatureInterface {
    @MainActor func makeProfileView() -> AnyView
}

enum ProfileRoute: Equatable {
    case editProfile
    case logout
}

protocol ProfileFeatureDelegate: AnyObject {
    func profileFeature(didSelect route: ProfileRoute)
}
