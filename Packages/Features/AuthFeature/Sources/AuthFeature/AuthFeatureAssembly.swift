import AppLogger
import AppStorage
import AuthFeatureInterface
import SwiftUI

// MARK: - Auth Feature Assembly

/// Concrete implementation of AuthFeatureInterface.
/// Wires the VIP-S chain internally. AppShell only needs to provide
/// logger, tokenStorage, and delegate.
public final class AuthFeatureAssembly: AuthFeatureInterface, LoginRouterDelegate {
    private let logger: LoggerProtocol
    private let tokenStorage: TokenStorageProtocol
    private weak var delegate: AuthFeatureDelegate?

    public init(logger: LoggerProtocol,
                tokenStorage: TokenStorageProtocol,
                delegate: AuthFeatureDelegate?)
    {
        self.logger = logger
        self.tokenStorage = tokenStorage
        self.delegate = delegate
    }

    // MARK: - Concrete Scene Factory

    @MainActor
    public func makeLoginScene() -> LoginView {
        let repository = makeRepository()
        let useCase: LoginUseCaseProtocol = LoginUseCase(
            repository: repository,
            tokenStorage: tokenStorage
        )

        let presenter = LoginPresenter()
        let interactor = LoginInteractor(loginUseCase: useCase)
        interactor.output = presenter
        interactor.router = self

        return LoginView(interactor: interactor, presenter: presenter)
    }

    // MARK: - AuthFeatureInterface

    @MainActor
    public func makeLoginView() -> AnyView {
        AnyView(makeLoginScene())
    }

    public var isAuthenticated: Bool {
        get async {
            tokenStorage.hasToken
        }
    }

    public func signOut() async throws {
        // Repository fans out to FirebaseAuthService which holds the Firebase coupling.
        try await makeRepository().logout()
        try tokenStorage.deleteToken()
    }

    // MARK: - Internal factory

    private func makeRepository() -> AuthRepositoryProtocol {
        let service: AuthServiceProtocol = FirebaseAuthService()
        return AuthRepository(service: service, logger: logger)
    }

    // MARK: - LoginRouterDelegate

    @MainActor
    func loginDidComplete(route: AuthRoute) {
        delegate?.authFeature(didComplete: route)
    }
}
