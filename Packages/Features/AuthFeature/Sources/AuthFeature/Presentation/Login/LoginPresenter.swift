import Foundation
import Observation
import AppCore

// MARK: - Login Presenter

@MainActor
@Observable
public final class LoginPresenter: LoginInteractorOutput {
    public private(set) var state = Login.ViewState()

    public init() {}

    func present(_ response: Login.Response) {
        switch response {
        case .loginLoading:
            state.isLoading = true
            state.errorMessage = nil

        case .loginSuccess:
            state.isLoading = false
            state.isLoginSuccessful = true

        case .loginFailure(let error):
            state.isLoading = false
            state.errorMessage = (error as? any AppErrorProtocol)?.userMessage
                ?? error.localizedDescription

        case .fieldUpdate(let email, let password):
            state.email = email
            state.password = password
            state.errorMessage = nil
        }
    }
}
