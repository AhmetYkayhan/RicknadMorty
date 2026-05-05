import Foundation

// MARK: - Network Client Protocol

public protocol NetworkClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
    func request(_ endpoint: Endpoint) async throws -> Data
}
