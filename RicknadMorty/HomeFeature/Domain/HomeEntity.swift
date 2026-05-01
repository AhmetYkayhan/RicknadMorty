import Foundation

// MARK: - Home Entity (Domain layer)

struct HomeEntity: Codable, Equatable, Hashable, Identifiable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let gender: String
    let origin: String
    let location: String
    let imageURL: URL?

    enum Status: String, Codable, Equatable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown = "unknown"
    }
}
