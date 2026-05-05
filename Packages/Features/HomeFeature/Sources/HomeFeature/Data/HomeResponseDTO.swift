import Foundation

// MARK: - Home Response DTOs (Data layer only)

struct HomePageResponseDTO: Decodable {
    let info: PageInfoDTO
    let results: [CharacterDTO]
}

struct PageInfoDTO: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

public struct CharacterDTO: Decodable {
    public let id: Int
    public let name: String
    public let status: String
    public let species: String
    public let gender: String
    public let origin: LocationDTO
    public let location: LocationDTO
    public let image: String
}

public struct LocationDTO: Decodable {
    public let name: String
    public let url: String
}
