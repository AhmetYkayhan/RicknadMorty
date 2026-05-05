import Testing
@testable import AuthFeatureInterface

@Suite("AuthFeatureInterface smoke")
struct AuthFeatureInterfaceSmokeTests {
    @Test("interface module loads")
    func loads() {
        #expect(Bool(true))
    }
}
