import Foundation
import AppNetwork

// MARK: - Auth Endpoints

enum AuthEndpoint: Endpoint {
    case login(LoginRequestDTO)
    case logout

    var path: String {
        switch self {
        case .login: return "/auth/login"
        case .logout: return "/auth/logout"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .logout: return .post
        }
    }

    var body: Data? {
        switch self {
        case .login(let dto):
            return try? JSONEncoder().encode(dto)
        case .logout:
            return nil
        }
    }
}
