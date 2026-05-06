import AppNetwork
import Foundation

// MARK: - Home Endpoints

enum HomeEndpoint: Endpoint {
    case characters(page: Int)

    var baseURL: String {
        "https://rickandmortyapi.com/api"
    }

    var path: String {
        switch self {
        case .characters: "/character"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .characters(page):
            [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
}
