import Foundation
import AuthFeatureInterface

// MARK: - Login Interactor Protocol

@MainActor
public protocol LoginInteractorProtocol: AnyObject {
    func handle(_ request: Login.Request)
}

// MARK: - Login Interactor Output (Interactor -> Presenter)

@MainActor
protocol LoginInteractorOutput: AnyObject {
    func present(_ response: Login.Response)
}

// MARK: - Login Router Delegate

@MainActor
protocol LoginRouterDelegate: AnyObject {
    func loginDidComplete(route: AuthRoute)
}

// MARK: - Login Interactor

@MainActor
public final class LoginInteractor: LoginInteractorProtocol {
    private let loginUseCase: LoginUseCaseProtocol
    weak var output: LoginInteractorOutput?
    weak var router: LoginRouterDelegate?

    private var email: String = ""
    private var password: String = ""

    init(loginUseCase: LoginUseCaseProtocol) {
        self.loginUseCase = loginUseCase
    }

    public func handle(_ request: Login.Request) {
        switch request {
        case .updateEmail(let value):
            email = value
            output?.present(.fieldUpdate(email: email, password: password))

        case .updatePassword(let value):
            password = value
            output?.present(.fieldUpdate(email: email, password: password))

        case .login:
            performLogin()

        case .forgotPassword:
            router?.loginDidComplete(route: .forgotPassword)
        }
    }

    // MARK: - Private

    private func performLogin() {
        output?.present(.loginLoading)

        Task { [weak self] in
            guard let self else { return }
            do {
                _ = try await loginUseCase.execute(
                    email: email,
                    password: password
                )
                output?.present(.loginSuccess)
                router?.loginDidComplete(route: .loginCompleted)
            } catch {
                output?.present(.loginFailure(error))
            }
        }
    }
}
