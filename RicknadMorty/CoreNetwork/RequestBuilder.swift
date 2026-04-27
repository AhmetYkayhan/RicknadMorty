import Foundation

// MARK: - Request Builder

struct RequestBuilder {
    private var baseURL: String
    private var path: String
    private var method: HTTPMethod
    private var headers: [String: String]
    private var queryItems: [URLQueryItem]
    private var body: Data?

    init(baseURL: String = "https://api.ricknadmorty.com/v1") {
        self.baseURL = baseURL
        self.path = ""
        self.method = .get
        self.headers = ["Content-Type": "application/json"]
        self.queryItems = []
    }

    func setPath(_ path: String) -> RequestBuilder {
        var copy = self
        copy.path = path
        return copy
    }

    func setMethod(_ method: HTTPMethod) -> RequestBuilder {
        var copy = self
        copy.method = method
        return copy
    }

    func addHeader(key: String, value: String) -> RequestBuilder {
        var copy = self
        copy.headers[key] = value
        return copy
    }

    func addQueryItem(name: String, value: String) -> RequestBuilder {
        var copy = self
        copy.queryItems.append(URLQueryItem(name: name, value: value))
        return copy
    }

    func setBody<T: Encodable>(_ body: T) throws -> RequestBuilder {
        var copy = self
        copy.body = try JSONEncoder().encode(body)
        return copy
    }

    func build() throws -> URLRequest {
        guard var components = URLComponents(string: baseURL + path) else {
            throw NetworkError.invalidURL
        }

        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }

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
