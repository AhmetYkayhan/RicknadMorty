import Foundation

// MARK: - Mock Token Storage (for testing / previews)

final class MockTokenStorage: TokenStorageProtocol {
    private var token: String?

    init(token: String? = nil) {
        self.token = token
    }

    func saveToken(_ token: String) throws {
        self.token = token
    }

    func getToken() throws -> String? {
        token
    }

    func deleteToken() throws {
        token = nil
    }

    var hasToken: Bool {
        token != nil
    }
}
