import Foundation

// MARK: - Home Endpoints

enum HomeEndpoint: Endpoint {
    case characters(page: Int)

    var baseURL: String { "https://rickandmortyapi.com/api" }

    var path: String {
        switch self {
        case .characters: return "/character"
        }
    }

    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .characters(let page):
            return [URLQueryItem(name: "page", value: "\(page)")]
        }
    }
}
