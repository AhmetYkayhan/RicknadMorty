import Foundation

// MARK: - Home Entity (Domain layer)

public struct HomeEntity: Codable, Equatable, Hashable, Identifiable {
    public let id: Int
    public let name: String
    public let status: Status
    public let species: String
    public let gender: String
    public let origin: String
    public let location: String
    public let imageURL: URL?

    public init(id: Int, name: String, status: Status, species: String,
                gender: String, origin: String, location: String, imageURL: URL?)
    {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.gender = gender
        self.origin = origin
        self.location = location
        self.imageURL = imageURL
    }

    public enum Status: String, Codable, Equatable {
        case alive = "Alive"
        case dead = "Dead"
        case unknown
    }
}
