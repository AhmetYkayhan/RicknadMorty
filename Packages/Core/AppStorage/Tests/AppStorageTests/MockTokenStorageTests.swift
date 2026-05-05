import Testing
@testable import AppStorage

@Suite("MockTokenStorage")
struct MockTokenStorageTests {
    @Test("save/get roundtrip")
    func roundtrip() throws {
        let storage = MockTokenStorage()
        try storage.saveToken("abc")
        #expect(try storage.getToken() == "abc")
        #expect(storage.hasToken == true)
        try storage.deleteToken()
        #expect(storage.hasToken == false)
    }
}
