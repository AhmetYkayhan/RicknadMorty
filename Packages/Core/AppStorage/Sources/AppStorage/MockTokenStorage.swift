import Foundation

// MARK: - Mock Token Storage (for testing / previews)

public final class MockTokenStorage: TokenStorageProtocol {
    private var token: String?

    public init(token: String? = nil) {
        self.token = token
    }

    public func saveToken(_ token: String) throws {
        self.token = token
    }

    public func getToken() throws -> String? {
        token
    }

    public func deleteToken() throws {
        token = nil
    }

    public var hasToken: Bool {
        token != nil
    }
}
