import Foundation
import AppLogger

// MARK: - Search Repository (Data layer implementation)

final class SearchRepository: SearchRepositoryProtocol {
    private let service: SearchServiceProtocol
    private let logger: LoggerProtocol

    init(service: SearchServiceProtocol, logger: LoggerProtocol) {
        self.service = service
        self.logger = logger
    }

    func search(type: SearchType, query: String) async throws -> [SearchResultEntity] {
        logger.info("Searching \(type.rawValue) for: \(query)")

        switch type {
        case .character:
            let dtos = try await service.searchCharacters(name: query)
            return dtos.map { .character(HomeMapper.map($0)) }
        case .episode:
            let dtos = try await service.searchEpisodes(name: query)
            return dtos.map { .episode(SearchMapper.map($0)) }
        case .location:
            let dtos = try await service.searchLocations(name: query)
            return dtos.map { .location(SearchMapper.map($0)) }
        }
    }
}
