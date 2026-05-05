import Testing
@testable import ProfileFeatureInterface

@Suite("ProfileFeatureInterface smoke")
struct ProfileFeatureInterfaceSmokeTests {
    @Test("interface module loads")
    func loads() {
        #expect(Bool(true))
    }
}
