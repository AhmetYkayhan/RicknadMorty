import Foundation

// MARK: - Token Storage Protocol

protocol TokenStorageProtocol {
    func saveToken(_ token: String) throws
    func getToken() throws -> String?
    func deleteToken() throws
    var hasToken: Bool { get }
}
