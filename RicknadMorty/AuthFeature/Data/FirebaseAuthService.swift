import Foundation
import FirebaseAuth

// MARK: - Firebase Auth Service

final class FirebaseAuthService: AuthServiceProtocol {

    func login(request: LoginRequestDTO) async throws -> LoginResponseDTO {
        let result: AuthDataResult
        do {
            result = try await Auth.auth().signIn(
                withEmail: request.email,
                password: request.password
            )
        } catch {
            throw mapFirebaseError(error)
        }

        let user = result.user
        let idToken = try await user.getIDToken()

        return LoginResponseDTO(
            userId: user.uid,
            email: user.email ?? "",
            accessToken: idToken,
            refreshToken: user.refreshToken ?? ""
        )
    }

    func logout() async throws {
        do {
            try Auth.auth().signOut()
        } catch {
            throw AppError.auth(.invalidCredentials)
        }
    }

    // MARK: - Error Mapping

    private func mapFirebaseError(_ error: Error) -> AppError {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.wrongPassword.rawValue,
             AuthErrorCode.invalidEmail.rawValue,
             AuthErrorCode.userNotFound.rawValue,
             AuthErrorCode.invalidCredential.rawValue:
            return .auth(.invalidCredentials)
        case AuthErrorCode.userDisabled.rawValue:
            return .auth(.accountLocked)
        case AuthErrorCode.networkError.rawValue:
            return .network(.noConnection)
        default:
            return .unknown(error.localizedDescription)
        }
    }
}
