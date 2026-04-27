import Foundation
import SwiftUI
import Observation

// MARK: - Login ViewModel

@MainActor
@Observable
final class LoginViewModel {
    private(set) var state = LoginViewState()

    private let loginUseCase: LoginUseCaseProtocol
    private weak var delegate: AuthFeatureDelegate?

    init(loginUseCase: LoginUseCaseProtocol,
         delegate: AuthFeatureDelegate?) {
        self.loginUseCase = loginUseCase
        self.delegate = delegate
    }

    // MARK: - Intents

    func updateEmail(_ email: String) {
        state.email = email
        state.errorMessage = nil
    }

    func updatePassword(_ password: String) {
        state.password = password
        state.errorMessage = nil
    }

    func login() {
        guard state.isFormValid else { return }

        state.isLoading = true
        state.errorMessage = nil

        Task {
            do {
                _ = try await loginUseCase.execute(
                    email: state.email,
                    password: state.password
                )
                state.isLoading = false
                state.isLoginSuccessful = true
                delegate?.authFeature(didComplete: .loginCompleted)
            } catch {
                state.isLoading = false
                state.errorMessage = (error as? any AppErrorProtocol)?.userMessage
                    ?? error.localizedDescription
            }
        }
    }

    func forgotPasswordTapped() {
        delegate?.authFeature(didComplete: .forgotPassword)
    }
}
