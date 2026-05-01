import Foundation

// MARK: - Home Mapper (DTO -> Entity)

enum HomeMapper {
    static func map(_ dto: CharacterDTO) -> HomeEntity {
        HomeEntity(
            id: dto.id,
            name: dto.name,
            status: HomeEntity.Status(rawValue: dto.status) ?? .unknown,
            species: dto.species,
            gender: dto.gender,
            origin: dto.origin.name,
            location: dto.location.name,
            imageURL: URL(string: dto.image)
        )
    }

    static func map(_ dtos: [CharacterDTO]) -> [HomeEntity] {
        dtos.map { map($0) }
    }
}
