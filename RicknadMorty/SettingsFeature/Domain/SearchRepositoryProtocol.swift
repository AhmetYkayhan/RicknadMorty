import Foundation

// MARK: - Search Repository Protocol (Domain layer)

protocol SearchRepositoryProtocol {
    func search(type: SearchType, query: String) async throws -> [SearchResultEntity]
}
