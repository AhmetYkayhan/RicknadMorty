import Foundation

// MARK: - Search Type

enum SearchType: String, CaseIterable, Identifiable, Equatable {
    case character = "Character"
    case episode = "Episode"
    case location = "Location"

    var id: String { rawValue }
}

// MARK: - Episode Entity

struct EpisodeEntity: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let name: String
    let episode: String
    let airDate: String
}

// MARK: - Location Entity

struct LocationEntity: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
}

// MARK: - Search Result Entity

enum SearchResultEntity: Identifiable, Hashable {
    case character(HomeEntity)
    case episode(EpisodeEntity)
    case location(LocationEntity)

    var id: String {
        switch self {
        case .character(let entity): return "character-\(entity.id)"
        case .episode(let entity): return "episode-\(entity.id)"
        case .location(let entity): return "location-\(entity.id)"
        }
    }
}
