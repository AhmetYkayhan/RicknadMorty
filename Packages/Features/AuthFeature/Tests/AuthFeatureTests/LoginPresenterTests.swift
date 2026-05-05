import Testing
@testable import AuthFeature

@MainActor
@Suite("LoginPresenter")
struct LoginPresenterTests {

    @Test("loginLoading sets isLoading and clears error")
    func loginLoading() {
        let presenter = LoginPresenter()
        presenter.present(.loginFailure(SampleError.boom))
        #expect(presenter.state.errorMessage != nil)

        presenter.present(.loginLoading)

        #expect(presenter.state.isLoading == true)
        #expect(presenter.state.errorMessage == nil)
    }

    @Test("loginSuccess clears loading and sets success flag")
    func loginSuccess() {
        let presenter = LoginPresenter()
        presenter.present(.loginLoading)

        presenter.present(.loginSuccess)

        #expect(presenter.state.isLoading == false)
        #expect(presenter.state.isLoginSuccessful == true)
    }

    @Test("loginFailure clears loading and sets error message")
    func loginFailure() {
        let presenter = LoginPresenter()
        presenter.present(.loginLoading)

        presenter.present(.loginFailure(SampleError.boom))

        #expect(presenter.state.isLoading == false)
        #expect(presenter.state.errorMessage != nil)
        #expect(presenter.state.isLoginSuccessful == false)
    }

    @Test("fieldUpdate mirrors values into state and clears error")
    func fieldUpdate() {
        let presenter = LoginPresenter()
        presenter.present(.loginFailure(SampleError.boom))

        presenter.present(.fieldUpdate(email: "a@b.com", password: "secret"))

        #expect(presenter.state.email == "a@b.com")
        #expect(presenter.state.password == "secret")
        #expect(presenter.state.errorMessage == nil)
    }
}

private enum SampleError: Error { case boom }
