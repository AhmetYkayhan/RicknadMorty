import Foundation

// MARK: - Base Application Error Protocol

protocol AppErrorProtocol: LocalizedError {
    var code: Int { get }
    var userMessage: String { get }
}

// MARK: - App Error

enum AppError: AppErrorProtocol {
    case network(NetworkError)
    case storage(StorageError)
    case auth(AuthError)
    case unknown(String)

    var code: Int {
        switch self {
        case .network(let error): return error.code
        case .storage(let error): return error.code
        case .auth(let error): return error.code
        case .unknown: return -1
        }
    }

    var userMessage: String {
        switch self {
        case .network(let error): return error.userMessage
        case .storage(let error): return error.userMessage
        case .auth(let error): return error.userMessage
        case .unknown(let message): return message
        }
    }

    var errorDescription: String? { userMessage }
}

// MARK: - Network Errors

enum NetworkError: AppErrorProtocol {
    case invalidURL
    case noData
    case decodingFailed
    case unauthorized
    case serverError(statusCode: Int)
    case timeout
    case noConnection
    case unknown(String)

    var code: Int {
        switch self {
        case .invalidURL: return 1001
        case .noData: return 1002
        case .decodingFailed: return 1003
        case .unauthorized: return 1004
        case .serverError(let statusCode): return statusCode
        case .timeout: return 1005
        case .noConnection: return 1006
        case .unknown: return 1099
        }
    }

    var userMessage: String {
        switch self {
        case .invalidURL: return "Invalid URL."
        case .noData: return "No data received."
        case .decodingFailed: return "Failed to process response."
        case .unauthorized: return "Session expired. Please login again."
        case .serverError: return "Server error. Please try again later."
        case .timeout: return "Request timed out."
        case .noConnection: return "No internet connection."
        case .unknown(let msg): return msg
        }
    }

    var errorDescription: String? { userMessage }
}

// MARK: - Storage Errors

enum StorageError: AppErrorProtocol {
    case saveFailed
    case readFailed
    case deleteFailed
    case notFound

    var code: Int {
        switch self {
        case .saveFailed: return 2001
        case .readFailed: return 2002
        case .deleteFailed: return 2003
        case .notFound: return 2004
        }
    }

    var userMessage: String {
        switch self {
        case .saveFailed: return "Failed to save data."
        case .readFailed: return "Failed to read data."
        case .deleteFailed: return "Failed to delete data."
        case .notFound: return "Data not found."
        }
    }

    var errorDescription: String? { userMessage }
}

// MARK: - Auth Errors

enum AuthError: AppErrorProtocol {
    case invalidCredentials
    case tokenExpired
    case accountLocked
    case registrationFailed

    var code: Int {
        switch self {
        case .invalidCredentials: return 3001
        case .tokenExpired: return 3002
        case .accountLocked: return 3003
        case .registrationFailed: return 3004
        }
    }

    var userMessage: String {
        switch self {
        case .invalidCredentials: return "Invalid email or password."
        case .tokenExpired: return "Session expired. Please login again."
        case .accountLocked: return "Account is locked. Contact support."
        case .registrationFailed: return "Registration failed. Try again."
        }
    }

    var errorDescription: String? { userMessage }
}
