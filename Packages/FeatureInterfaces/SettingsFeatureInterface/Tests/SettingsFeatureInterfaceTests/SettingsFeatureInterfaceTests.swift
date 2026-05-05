import Testing
@testable import SettingsFeatureInterface

@Suite("SettingsFeatureInterface smoke")
struct SettingsFeatureInterfaceSmokeTests {
    @Test("interface module loads")
    func loads() {
        #expect(Bool(true))
    }
}
