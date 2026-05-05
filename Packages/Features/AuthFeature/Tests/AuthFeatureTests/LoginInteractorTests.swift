import Testing
@testable import AuthFeature
import AuthFeatureInterface

@MainActor
@Suite("LoginInteractor")
struct LoginInteractorTests {

    final class StubUseCase: LoginUseCaseProtocol {
        var capturedEmail: String?
        var capturedPassword: String?
        var result: Result<AuthEntity, Error> = .failure(StubError.notSet)

        func execute(email: String, password: String) async throws -> AuthEntity {
            capturedEmail = email
            capturedPassword = password
            return try result.get()
        }
    }

    final class SpyRouter: LoginRouterDelegate {
        var capturedRoute: AuthRoute?
        func loginDidComplete(route: AuthRoute) {
            capturedRoute = route
        }
    }

    enum StubError: Error { case notSet }

    @Test("forgotPassword routes via router delegate")
    func forgotPassword() {
        let useCase = StubUseCase()
        let presenter = LoginPresenter()
        let router = SpyRouter()
        let sut = LoginInteractor(loginUseCase: useCase)
        sut.output = presenter
        sut.router = router

        sut.handle(.forgotPassword)

        #expect(router.capturedRoute == .forgotPassword)
        #expect(useCase.capturedEmail == nil)
    }

    @Test("updateEmail and updatePassword reach presenter as fieldUpdate")
    func fieldUpdates() {
        let useCase = StubUseCase()
        let presenter = LoginPresenter()
        let router = SpyRouter()
        let sut = LoginInteractor(loginUseCase: useCase)
        sut.output = presenter
        sut.router = router

        sut.handle(.updateEmail("a@b.com"))
        sut.handle(.updatePassword("secret"))

        #expect(presenter.state.email == "a@b.com")
        #expect(presenter.state.password == "secret")
    }

    @Test("login success forwards to use case and notifies router")
    func loginSuccess() async {
        let useCase = StubUseCase()
        useCase.result = .success(
            AuthEntity(
                userId: "u1",
                email: "a@b.com",
                accessToken: "token",
                refreshToken: "refresh"
            )
        )
        let presenter = LoginPresenter()
        let router = SpyRouter()
        let sut = LoginInteractor(loginUseCase: useCase)
        sut.output = presenter
        sut.router = router

        sut.handle(.updateEmail("a@b.com"))
        sut.handle(.updatePassword("secret"))
        sut.handle(.login)

        // Wait for async login Task
        await waitForLoginCompletion(presenter: presenter)

        #expect(useCase.capturedEmail == "a@b.com")
        #expect(useCase.capturedPassword == "secret")
        #expect(presenter.state.isLoginSuccessful == true)
        #expect(presenter.state.isLoading == false)
        #expect(router.capturedRoute == .loginCompleted)
    }

    @Test("login failure forwards error to presenter and skips routing")
    func loginFailure() async {
        let useCase = StubUseCase()
        useCase.result = .failure(StubError.notSet)
        let presenter = LoginPresenter()
        let router = SpyRouter()
        let sut = LoginInteractor(loginUseCase: useCase)
        sut.output = presenter
        sut.router = router

        sut.handle(.updateEmail("a@b.com"))
        sut.handle(.updatePassword("secret"))
        sut.handle(.login)

        await waitForLoginFailure(presenter: presenter)

        #expect(presenter.state.isLoading == false)
        #expect(presenter.state.errorMessage != nil)
        #expect(presenter.state.isLoginSuccessful == false)
        #expect(router.capturedRoute == nil)
    }

    // MARK: - Helpers

    private func waitForLoginCompletion(presenter: LoginPresenter) async {
        for _ in 0..<50 {
            if presenter.state.isLoginSuccessful || presenter.state.errorMessage != nil { return }
            try? await Task.sleep(nanoseconds: 20_000_000)
        }
    }

    private func waitForLoginFailure(presenter: LoginPresenter) async {
        for _ in 0..<50 {
            if presenter.state.errorMessage != nil { return }
            try? await Task.sleep(nanoseconds: 20_000_000)
        }
    }
}
