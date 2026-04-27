import Foundation

// MARK: - Base View State Protocol

protocol ViewStateProtocol {
    var isLoading: Bool { get }
    var errorMessage: String? { get }
}
