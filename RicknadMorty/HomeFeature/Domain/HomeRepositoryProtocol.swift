import Foundation

// MARK: - Home Repository Protocol (Domain layer)

protocol HomeRepositoryProtocol {
    func getCharacters(page: Int) async throws -> [HomeEntity]
}
