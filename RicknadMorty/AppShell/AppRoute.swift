import Foundation

// MARK: - App Route

/// Top-level navigation routes managed by AppCoordinator
enum AppRoute: Equatable {
    case login
    case home
    case characterDetail(id: Int)
    case settings
    case profile
}
