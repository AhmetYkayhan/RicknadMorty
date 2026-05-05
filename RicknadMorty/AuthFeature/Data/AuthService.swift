import Foundation
import AppNetwork

// MARK: - Auth Service Protocol

protocol AuthServiceProtocol {
    func login(request: LoginRequestDTO) async throws -> LoginResponseDTO
    func logout() async throws
}

// MARK: - Auth Service

final class AuthService: AuthServiceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func login(request: LoginRequestDTO) async throws -> LoginResponseDTO {
        try await networkClient.request(AuthEndpoint.login(request))
    }

    func logout() async throws {
        _ = try await networkClient.request(AuthEndpoint.logout)
    }
}

// MARK: - Mock Auth Service (for testing / previews)

final class MockAuthService: AuthServiceProtocol {
    var loginResult: Result<LoginResponseDTO, Error> = .success(
        LoginResponseDTO(
            userId: "mock-user-1",
            email: "test@example.com",
            accessToken: "mock-access-token",
            refreshToken: "mock-refresh-token"
        )
    )

    func login(request: LoginRequestDTO) async throws -> LoginResponseDTO {
        // Simulate network delay
        try await Task.sleep(nanoseconds: 500_000_000)
        return try loginResult.get()
    }

    func logout() async throws {
        try await Task.sleep(nanoseconds: 200_000_000)
    }
}
