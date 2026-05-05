import SwiftUI

// MARK: - Auth Feature Interface

/// Public protocol that other modules use to interact with AuthFeature.
/// Feature modules never import each other directly — they depend on interfaces.
public protocol AuthFeatureInterface {
    /// Creates the login view to be composed by the coordinator
    @MainActor func makeLoginView() -> AnyView

    /// Current authentication status
    var isAuthenticated: Bool { get async }
}

// MARK: - Auth Feature Route

/// Navigation outputs from the auth feature
public enum AuthRoute: Equatable {
    case loginCompleted
    case forgotPassword
    case register
}

// MARK: - Auth Feature Delegate

/// Delegate protocol for auth feature navigation events
public protocol AuthFeatureDelegate: AnyObject {
    func authFeature(didComplete route: AuthRoute)
}
