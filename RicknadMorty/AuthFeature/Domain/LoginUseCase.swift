import Foundation
import AppStorage

// MARK: - Login Use Case Protocol

protocol LoginUseCaseProtocol {
    func execute(email: String, password: String) async throws -> AuthEntity
}

// MARK: - Login Use Case

final class LoginUseCase: LoginUseCaseProtocol {
    private let repository: AuthRepositoryProtocol
    private let tokenStorage: TokenStorageProtocol

    init(repository: AuthRepositoryProtocol,
         tokenStorage: TokenStorageProtocol) {
        self.repository = repository
        self.tokenStorage = tokenStorage
    }

    func execute(email: String, password: String) async throws -> AuthEntity {
        let authEntity = try await repository.login(email: email, password: password)

        // Persist token after successful login
        try tokenStorage.saveToken(authEntity.accessToken)

        return authEntity
    }
}
