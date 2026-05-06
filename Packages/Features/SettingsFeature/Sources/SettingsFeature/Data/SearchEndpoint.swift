import AppNetwork
import Foundation

// MARK: - Search Endpoints (Rick and Morty API)

enum SearchEndpoint: Endpoint {
    case characters(name: String)
    case episodes(name: String)
    case locations(name: String)

    var baseURL: String {
        "https://rickandmortyapi.com/api"
    }

    var path: String {
        switch self {
        case .characters: "/character"
        case .episodes: "/episode"
        case .locations: "/location"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case let .characters(name),
             let .episodes(name),
             let .locations(name):
            [URLQueryItem(name: "name", value: name)]
        }
    }
}
