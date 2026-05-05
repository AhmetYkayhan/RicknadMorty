import Foundation

// MARK: - Search Mapper (DTO -> Entity)

enum SearchMapper {
    static func map(_ dto: EpisodeDTO) -> EpisodeEntity {
        EpisodeEntity(
            id: dto.id,
            name: dto.name,
            episode: dto.episode,
            airDate: dto.airDate
        )
    }

    static func map(_ dto: LocationFullDTO) -> LocationEntity {
        LocationEntity(
            id: dto.id,
            name: dto.name,
            type: dto.type,
            dimension: dto.dimension
        )
    }
}
