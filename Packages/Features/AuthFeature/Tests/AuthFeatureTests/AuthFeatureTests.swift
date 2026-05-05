import Testing
@testable import AuthFeature

@Suite("AuthFeature smoke")
struct AuthFeatureSmokeTests {
    @Test("module loads")
    func loads() {
        #expect(Bool(true))
    }
}
