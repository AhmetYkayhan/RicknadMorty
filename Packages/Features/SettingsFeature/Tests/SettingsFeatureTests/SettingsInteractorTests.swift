import Testing
@testable import SettingsFeature
@testable import SettingsFeatureInterface

@MainActor
@Suite("SettingsInteractor")
struct SettingsInteractorTests {
    final class SpyDelegate: SettingsFeatureDelegate {
        var route: SettingsRoute?
        func settingsFeature(didSelect route: SettingsRoute) {
            self.route = route
        }
    }

    @Test("submit with empty query is no-op")
    func submitEmpty() {
        let presenter = SettingsPresenter()
        let delegate = SpyDelegate()
        let sut = SettingsInteractor(presenter: presenter, delegate: delegate)

        sut.handle(.submit)

        #expect(presenter.viewState.pendingSearch == nil)
    }

    @Test("submit with whitespace-only query is no-op")
    func submitWhitespace() {
        let presenter = SettingsPresenter()
        let sut = SettingsInteractor(presenter: presenter, delegate: nil)

        sut.handle(.updateQuery("   "))
        sut.handle(.submit)

        #expect(presenter.viewState.pendingSearch == nil)
    }

    @Test("submit triggers pendingSearch with current params")
    func submitTriggers() {
        let presenter = SettingsPresenter()
        let sut = SettingsInteractor(presenter: presenter, delegate: nil)

        sut.handle(.updateQuery("rick"))
        sut.handle(.updateType(.episode))
        sut.handle(.submit)

        #expect(presenter.viewState.pendingSearch == .init(query: "rick", type: .episode))
    }

    @Test("submit trims whitespace before triggering")
    func submitTrims() {
        let presenter = SettingsPresenter()
        let sut = SettingsInteractor(presenter: presenter, delegate: nil)

        sut.handle(.updateQuery("  morty  "))
        sut.handle(.submit)

        #expect(presenter.viewState.pendingSearch?.query == "morty")
    }

    @Test("clearQuery resets query to empty")
    func clear() {
        let presenter = SettingsPresenter()
        let sut = SettingsInteractor(presenter: presenter, delegate: nil)

        sut.handle(.updateQuery("rick"))
        sut.handle(.clearQuery)

        #expect(presenter.viewState.query.isEmpty)
    }

    @Test("logoutTapped routes via delegate")
    func logout() {
        let presenter = SettingsPresenter()
        let delegate = SpyDelegate()
        let sut = SettingsInteractor(presenter: presenter, delegate: delegate)

        sut.handle(.logoutTapped)

        #expect(delegate.route == .logout)
    }

    @Test("consumeSearchTrigger clears pendingSearch")
    func consume() {
        let presenter = SettingsPresenter()
        let sut = SettingsInteractor(presenter: presenter, delegate: nil)
        sut.handle(.updateQuery("morty"))
        sut.handle(.submit)
        #expect(presenter.viewState.pendingSearch != nil)

        sut.handle(.consumeSearchTrigger)
        #expect(presenter.viewState.pendingSearch == nil)
    }
}
