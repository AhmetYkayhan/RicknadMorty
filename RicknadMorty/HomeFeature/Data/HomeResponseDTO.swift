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

struct CharacterDTO: Decodable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let origin: LocationDTO
    let location: LocationDTO
    let image: String
}

struct LocationDTO: Decodable {
    let name: String
    let url: String
}
