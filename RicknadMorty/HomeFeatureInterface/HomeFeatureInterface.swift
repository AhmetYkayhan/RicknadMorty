import SwiftUI

// MARK: - Home Feature Interface

/// Public protocol that other modules use to interact with HomeFeature
protocol HomeFeatureInterface {
    @MainActor func makeHomeView() -> AnyView
}

// MARK: - Home Feature Route

enum HomeRoute: Equatable {
    case characterDetail(id: Int)
    case settings
    case profile
}

// MARK: - Home Feature Delegate

protocol HomeFeatureDelegate: AnyObject {
    func homeFeature(didSelect route: HomeRoute)
}
