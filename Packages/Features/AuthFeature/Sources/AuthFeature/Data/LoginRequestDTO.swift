import Foundation

// MARK: - Login Request DTO (Data layer only)

struct LoginRequestDTO: Encodable {
    let email: String
    let password: String
}
