import Foundation
import HomeFeature

// MARK: - Search Type

public enum SearchType: String, CaseIterable, Identifiable, Equatable, Hashable {
    case character = "Character"
    case episode = "Episode"
    case location = "Location"

    public var id: String { rawValue }
}

// MARK: - Episode Entity

public struct EpisodeEntity: Codable, Equatable, Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let episode: String
    public let airDate: String

    public init(id: Int, name: String, episode: String, airDate: String) {
        self.id = id
        self.name = name
        self.episode = episode
        self.airDate = airDate
    }
}

// MARK: - Location Entity

public struct LocationEntity: Codable, Equatable, Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let type: String
    public let dimension: String

    public init(id: Int, name: String, type: String, dimension: String) {
        self.id = id
        self.name = name
        self.type = type
        self.dimension = dimension
    }
}

// MARK: - Search Result Entity

public enum SearchResultEntity: Identifiable, Hashable {
    case character(HomeEntity)
    case episode(EpisodeEntity)
    case location(LocationEntity)

    public var id: String {
        switch self {
        case .character(let entity): return "character-\(entity.id)"
        case .episode(let entity): return "episode-\(entity.id)"
        case .location(let entity): return "location-\(entity.id)"
        }
    }
}
