import Foundation

// MARK: - Auth Repository Protocol (Domain layer)

public protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> AuthEntity
    func logout() async throws
}
