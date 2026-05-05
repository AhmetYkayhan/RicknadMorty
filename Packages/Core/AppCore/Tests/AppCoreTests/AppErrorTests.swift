import Testing
@testable import AppCore

@Suite("AppCore smoke")
struct AppCoreSmokeTests {
    @Test("AppCore imports successfully")
    func canImportModule() {
        #expect(Bool(true))
    }
}
