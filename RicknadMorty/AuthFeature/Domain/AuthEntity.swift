import Foundation

// MARK: - Auth Entity (Domain layer)

struct AuthEntity: Equatable {
    let userId: String
    let email: String
    let accessToken: String
    let refreshToken: String
}
