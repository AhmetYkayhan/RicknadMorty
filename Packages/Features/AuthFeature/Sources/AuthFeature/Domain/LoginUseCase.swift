import AppStorage
import Foundation

// MARK: - Login Use Case Protocol

public protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) async throws -> AuthEntity
}

// MARK: - Login Use Case

public final class LoginUseCase: LoginUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    private let tokenStorage: TokenStorageProtocol

    public init(repository: AuthRepositoryProtocol,
                tokenStorage: TokenStorageProtocol)
    {
        self.repository = repository
        self.tokenStorage = tokenStorage
    }

    public func execute(email: String, password: String) async throws -> AuthEntity {
        let authEntity = try await repository.login(email: email, password: password)

        // Persist token after successful login
        try tokenStorage.saveToken(authEntity.accessToken)

        return authEntity
    }
}
