import SwiftUI

// MARK: - Auth Feature Assembly

/// Concrete implementation of AuthFeatureInterface.
/// AppShell creates this and injects dependencies.
final class AuthFeatureAssembly: AuthFeatureInterface {
    private let loginUseCase: LoginUseCaseProtocol
    private let tokenStorage: TokenStorageProtocol
    private weak var delegate: AuthFeatureDelegate?

    init(loginUseCase: LoginUseCaseProtocol,
         tokenStorage: TokenStorageProtocol,
         delegate: AuthFeatureDelegate?) {
        self.loginUseCase = loginUseCase
        self.tokenStorage = tokenStorage
        self.delegate = delegate
    }

    @MainActor
    func makeLoginView() -> AnyView {
        let viewModel = LoginViewModel(
            loginUseCase: loginUseCase,
            delegate: delegate
        )
        return AnyView(LoginView(viewModel: viewModel))
    }

    var isAuthenticated: Bool {
        get async {
            tokenStorage.hasToken
        }
    }
}
