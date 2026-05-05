import Foundation

// MARK: - Get Home Use Case Protocol

public protocol GetHomeUseCaseProtocol {
    func execute(page: Int) async throws -> [HomeEntity]
}

// MARK: - Get Home Use Case

public final class GetHomeUseCase: GetHomeUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(page: Int) async throws -> [HomeEntity] {
        try await repository.getCharacters(page: page)
    }
}
