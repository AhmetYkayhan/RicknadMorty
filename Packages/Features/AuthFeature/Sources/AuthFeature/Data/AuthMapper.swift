import Foundation

// MARK: - Auth Mapper (DTO -> Entity)

enum AuthMapper {
    static func map(_ dto: LoginResponseDTO) -> AuthEntity {
        AuthEntity(
            userId: dto.userId,
            email: dto.email,
            accessToken: dto.accessToken,
            refreshToken: dto.refreshToken
        )
    }
}
