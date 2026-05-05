import Testing
@testable import HomeFeatureInterface

@Suite("HomeFeatureInterface smoke")
struct HomeFeatureInterfaceSmokeTests {
    @Test("interface module loads")
    func loads() {
        #expect(Bool(true))
    }
}
