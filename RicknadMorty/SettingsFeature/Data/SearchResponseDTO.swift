import Foundation

// MARK: - Search Response DTOs (Data layer only)

struct CharacterSearchResponseDTO: Decodable {
    let results: [CharacterDTO]
}

struct EpisodeSearchResponseDTO: Decodable {
    let results: [EpisodeDTO]
}

struct LocationSearchResponseDTO: Decodable {
    let results: [LocationFullDTO]
}

struct EpisodeDTO: Decodable {
    let id: Int
    let name: String
    let episode: String
    let airDate: String

    enum CodingKeys: String, CodingKey {
        case id, name, episode
        case airDate = "air_date"
    }
}

struct LocationFullDTO: Decodable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
}
