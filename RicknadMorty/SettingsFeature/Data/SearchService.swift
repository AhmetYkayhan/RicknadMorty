import Foundation

// MARK: - Search Service Protocol

protocol SearchServiceProtocol {
    func searchCharacters(name: String) async throws -> [CharacterDTO]
    func searchEpisodes(name: String) async throws -> [EpisodeDTO]
    func searchLocations(name: String) async throws -> [LocationFullDTO]
}

// MARK: - Search Service

final class SearchService: SearchServiceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func searchCharacters(name: String) async throws -> [CharacterDTO] {
        do {
            let response: CharacterSearchResponseDTO = try await networkClient.request(
                SearchEndpoint.characters(name: name)
            )
            return response.results
        } catch let error as NetworkError {
            return try mapEmptyOrThrow(error)
        }
    }

    func searchEpisodes(name: String) async throws -> [EpisodeDTO] {
        do {
            let response: EpisodeSearchResponseDTO = try await networkClient.request(
                SearchEndpoint.episodes(name: name)
            )
            return response.results
        } catch let error as NetworkError {
            return try mapEmptyOrThrow(error)
        }
    }

    func searchLocations(name: String) async throws -> [LocationFullDTO] {
        do {
            let response: LocationSearchResponseDTO = try await networkClient.request(
                SearchEndpoint.locations(name: name)
            )
            return response.results
        } catch let error as NetworkError {
            return try mapEmptyOrThrow(error)
        }
    }

    /// Rick and Morty API responds with 404 when no results match. Treat that as empty list.
    private func mapEmptyOrThrow<T>(_ error: NetworkError) throws -> [T] {
        if case .serverError(let status) = error, status == 404 {
            return []
        }
        throw error
    }
}
