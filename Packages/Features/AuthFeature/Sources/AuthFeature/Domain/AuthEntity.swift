import Foundation

// MARK: - Auth Entity (Domain layer)

public struct AuthEntity: Equatable {
    public let userId: String
    public let email: String
    public let accessToken: String
    public let refreshToken: String

    public init(userId: String, email: String, accessToken: String, refreshToken: String) {
        self.userId = userId
        self.email = email
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}
