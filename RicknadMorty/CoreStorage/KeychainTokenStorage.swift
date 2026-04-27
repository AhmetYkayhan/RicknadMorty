import Foundation
import Security

// MARK: - Keychain Token Storage

final class KeychainTokenStorage: TokenStorageProtocol {
    private let service: String
    private let account: String

    init(service: String = "com.ricknadmorty.auth",
         account: String = "accessToken") {
        self.service = service
        self.account = account
    }

    func saveToken(_ token: String) throws {
        // Delete existing first
        try? deleteToken()

        guard let data = token.data(using: .utf8) else {
            throw StorageError.saveFailed
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw StorageError.saveFailed
        }
    }

    func getToken() throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        switch status {
        case errSecSuccess:
            guard let data = result as? Data,
                  let token = String(data: data, encoding: .utf8) else {
                throw StorageError.readFailed
            }
            return token
        case errSecItemNotFound:
            return nil
        default:
            throw StorageError.readFailed
        }
    }

    func deleteToken() throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw StorageError.deleteFailed
        }
    }

    var hasToken: Bool {
        (try? getToken()) != nil
    }
}
