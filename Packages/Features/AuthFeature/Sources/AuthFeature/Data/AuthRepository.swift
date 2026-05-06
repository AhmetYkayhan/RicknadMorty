import AppLogger
import Foundation

// MARK: - Auth Repository (Data layer implementation)

final class AuthRepository: AuthRepositoryProtocol {
    private let service: AuthServiceProtocol
    private let logger: LoggerProtocol

    init(service: AuthServiceProtocol, logger: LoggerProtocol) {
        self.service = service
        self.logger = logger
    }

    func login(email: String, password: String) async throws -> AuthEntity {
        logger.info("Attempting login for \(email)")

        let request = LoginRequestDTO(email: email, password: password)
        let response = try await service.login(request: request)
        let entity = AuthMapper.map(response)

        logger.info("Login successful for user: \(entity.userId)")
        return entity
    }

    func logout() async throws {
        logger.info("Logging out")
        try await service.logout()
    }
}
