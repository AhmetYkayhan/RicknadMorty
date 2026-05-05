import Foundation
import AppNetwork

// MARK: - Search Endpoints (Rick and Morty API)

enum SearchEndpoint: Endpoint {
    case characters(name: String)
    case episodes(name: String)
    case locations(name: String)

    var baseURL: String { "https://rickandmortyapi.com/api" }

    var path: String {
        switch self {
        case .characters: return "/character"
        case .episodes: return "/episode"
        case .locations: return "/location"
        }
    }

    var method: HTTPMethod { .get }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .characters(let name),
             .episodes(let name),
             .locations(let name):
            return [URLQueryItem(name: "name", value: name)]
        }
    }
}
