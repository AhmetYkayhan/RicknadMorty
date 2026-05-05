import Foundation

// MARK: - Search Use Case Protocol

public protocol SearchUseCaseProtocol {
    func execute(type: SearchType, query: String) async throws -> [SearchResultEntity]
}

// MARK: - Search Use Case

public final class SearchUseCase: SearchUseCaseProtocol {
    private let repository: SearchRepositoryProtocol

    init(repository: SearchRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(type: SearchType, query: String) async throws -> [SearchResultEntity] {
        try await repository.search(type: type, query: query)
    }
}
