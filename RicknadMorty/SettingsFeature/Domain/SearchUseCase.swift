import Foundation

// MARK: - Search Use Case Protocol

protocol SearchUseCaseProtocol {
    func execute(type: SearchType, query: String) async throws -> [SearchResultEntity]
}

// MARK: - Search Use Case

final class SearchUseCase: SearchUseCaseProtocol {
    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    func execute(type: SearchType, query: String) async throws -> [SearchResultEntity] {
        try await repository.search(type: type, query: query)
    }
}
