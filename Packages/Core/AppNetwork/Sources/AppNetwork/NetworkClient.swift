import Foundation
import AppCore
import AppLogger

// MARK: - Network Client

public final class NetworkClient: NetworkClientProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let logger: LoggerProtocol

    public init(session: URLSession = .shared,
                decoder: JSONDecoder = JSONDecoder(),
                logger: LoggerProtocol) {
        self.session = session
        self.decoder = decoder
        self.logger = logger
    }

    public func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let data = try await request(endpoint)

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            logger.error("Decoding failed for \(T.self): \(error.localizedDescription)")
            throw NetworkError.decodingFailed
        }
    }

    public func request(_ endpoint: Endpoint) async throws -> Data {
        let urlRequest: URLRequest
        do {
            urlRequest = try endpoint.asURLRequest()
        } catch {
            logger.error("Invalid URL: \(endpoint.path)")
            throw NetworkError.invalidURL
        }

        logger.debug("[\(endpoint.method.rawValue)] \(urlRequest.url?.absoluteString ?? "")")

        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch let error as URLError {
            switch error.code {
            case .timedOut:
                throw NetworkError.timeout
            case .notConnectedToInternet, .networkConnectionLost:
                throw NetworkError.noConnection
            default:
                throw NetworkError.unknown(error.localizedDescription)
            }
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown("Invalid response type")
        }

        logger.debug("Response status: \(httpResponse.statusCode)")

        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 401:
            throw NetworkError.unauthorized
        case 400...499:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.unknown("Unexpected status code: \(httpResponse.statusCode)")
        }
    }
}
