import Testing
@testable import AppNetwork

@Suite("HTTPMethod")
struct HTTPMethodTests {
    @Test("rawValue is uppercase verb")
    func rawValue() {
        #expect(HTTPMethod.get.rawValue == "GET")
        #expect(HTTPMethod.post.rawValue == "POST")
        #expect(HTTPMethod.put.rawValue == "PUT")
        #expect(HTTPMethod.patch.rawValue == "PATCH")
        #expect(HTTPMethod.delete.rawValue == "DELETE")
    }
}
