import Foundation

// MARK: - Home Service Protocol

protocol HomeServiceProtocol {
    func getCharacters(page: Int) async throws -> HomePageResponseDTO
}

// MARK: - Home Service

final class HomeService: HomeServiceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func getCharacters(page: Int) async throws -> HomePageResponseDTO {
        try await networkClient.request(HomeEndpoint.characters(page: page))
    }
}

// MARK: - Mock Home Service (for testing / previews)

final class MockHomeService: HomeServiceProtocol {
    func getCharacters(page: Int) async throws -> HomePageResponseDTO {
        try await Task.sleep(nanoseconds: 500_000_000)

        let characters = [
            CharacterDTO(id: 1, name: "Rick Sanchez", status: "Alive", species: "Human", image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"),
            CharacterDTO(id: 2, name: "Morty Smith", status: "Alive", species: "Human", image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg"),
            CharacterDTO(id: 3, name: "Summer Smith", status: "Alive", species: "Human", image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg"),
            CharacterDTO(id: 4, name: "Beth Smith", status: "Alive", species: "Human", image: "https://rickandmortyapi.com/api/character/avatar/4.jpeg"),
            CharacterDTO(id: 5, name: "Jerry Smith", status: "Alive", species: "Human", image: "https://rickandmortyapi.com/api/character/avatar/5.jpeg")
        ]

        return HomePageResponseDTO(
            info: PageInfoDTO(count: 5, pages: 1, next: nil, prev: nil),
            results: characters
        )
    }
}
