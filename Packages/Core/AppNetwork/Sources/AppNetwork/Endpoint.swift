import Foundation
import AppCore

// MARK: - Endpoint Protocol

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

public extension Endpoint {
    var baseURL: String { "https://api.ricknadmorty.com/v1" }
    var headers: [String: String]? { ["Content-Type": "application/json"] }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }
}

// MARK: - URL Construction

public extension Endpoint {
    func asURLRequest() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        components.queryItems = queryItems

        guard let url = components.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request.httpBody = body
        request.timeoutInterval = 30

        return request
    }
}
