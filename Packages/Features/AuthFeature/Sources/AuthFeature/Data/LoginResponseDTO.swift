import Foundation

// MARK: - Login Response DTO (Data layer only)

struct LoginResponseDTO: Decodable {
    let userId: String
    let email: String
    let accessToken: String
    let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case email
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
