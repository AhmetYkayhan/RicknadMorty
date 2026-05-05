import Foundation

// MARK: - Base View State Protocol

public protocol ViewStateProtocol {
    var isLoading: Bool { get }
    var errorMessage: String? { get }
}
