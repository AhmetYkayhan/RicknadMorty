import SwiftUI

// MARK: - Profile Feature Interface (Stub)

public protocol ProfileFeatureInterface {
    @MainActor
    func makeProfileView() -> AnyView
}

public enum ProfileRoute: Equatable {
    case editProfile
    case logout
}

public protocol ProfileFeatureDelegate: AnyObject {
    func profileFeature(didSelect route: ProfileRoute)
}
