import AppNetwork
import Foundation

// MARK: - Auth Endpoints

enum AuthEndpoint: Endpoint {
    case login(LoginRequestDTO)
    case logout

    var baseURL: String {
        "https://api.ricknadmorty.com/v1"
    }

    var path: String {
        switch self {
        case .login: "/auth/login"
        case .logout: "/auth/logout"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login: .post
        case .logout: .post
        }
    }

    var body: Data? {
        switch self {
        case let .login(dto):
            try? JSONEncoder().encode(dto)
        case .logout:
            nil
        }
    }
}
