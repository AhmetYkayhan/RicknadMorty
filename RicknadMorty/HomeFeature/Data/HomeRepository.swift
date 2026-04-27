import Foundation

// MARK: - Home Repository (Data layer implementation)

final class HomeRepository: HomeRepositoryProtocol {
    private let service: HomeServiceProtocol
    private let logger: LoggerProtocol

    init(service: HomeServiceProtocol, logger: LoggerProtocol) {
        self.service = service
        self.logger = logger
    }

    func getCharacters(page: Int) async throws -> [HomeEntity] {
        logger.info("Fetching characters page: \(page)")

        let response = try await service.getCharacters(page: page)
        let entities = HomeMapper.map(response.results)

        logger.info("Fetched \(entities.count) characters")
        return entities
    }
}
