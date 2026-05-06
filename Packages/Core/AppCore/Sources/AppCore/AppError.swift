import Foundation

// MARK: - Base Application Error Protocol

public protocol AppErrorProtocol: LocalizedError {
    var code: Int { get }
    var userMessage: String { get }
}

// MARK: - App Error

public enum AppError: AppErrorProtocol {
    case network(NetworkError)
    case storage(StorageError)
    case auth(AuthError)
    case unknown(String)

    public var code: Int {
        switch self {
        case let .network(error): error.code
        case let .storage(error): error.code
        case let .auth(error): error.code
        case .unknown: -1
        }
    }

    public var userMessage: String {
        switch self {
        case let .network(error): error.userMessage
        case let .storage(error): error.userMessage
        case let .auth(error): error.userMessage
        case let .unknown(message): message
        }
    }

    public var errorDescription: String? {
        userMessage
    }
}

// MARK: - Network Errors

public enum NetworkError: AppErrorProtocol {
    case invalidURL
    case noData
    case decodingFailed
    case unauthorized
    case serverError(statusCode: Int)
    case timeout
    case noConnection
    case unknown(String)

    public var code: Int {
        switch self {
        case .invalidURL: 1001
        case .noData: 1002
        case .decodingFailed: 1003
        case .unauthorized: 1004
        case let .serverError(statusCode): statusCode
        case .timeout: 1005
        case .noConnection: 1006
        case .unknown: 1099
        }
    }

    public var userMessage: String {
        switch self {
        case .invalidURL: "Invalid URL."
        case .noData: "No data received."
        case .decodingFailed: "Failed to process response."
        case .unauthorized: "Session expired. Please login again."
        case .serverError: "Server error. Please try again later."
        case .timeout: "Request timed out."
        case .noConnection: "No internet connection."
        case let .unknown(msg): msg
        }
    }

    public var errorDescription: String? {
        userMessage
    }
}

// MARK: - Storage Errors

public enum StorageError: AppErrorProtocol {
    case saveFailed
    case readFailed
    case deleteFailed
    case notFound

    public var code: Int {
        switch self {
        case .saveFailed: 2001
        case .readFailed: 2002
        case .deleteFailed: 2003
        case .notFound: 2004
        }
    }

    public var userMessage: String {
        switch self {
        case .saveFailed: "Failed to save data."
        case .readFailed: "Failed to read data."
        case .deleteFailed: "Failed to delete data."
        case .notFound: "Data not found."
        }
    }

    public var errorDescription: String? {
        userMessage
    }
}

// MARK: - Generic App Error

/// Adapts any non-`AppErrorProtocol` Swift `Error` into an `AppErrorProtocol`,
/// so presenters can rely on a single error contract regardless of source.
public struct GenericAppError: AppErrorProtocol {
    public let underlying: Error

    public init(_ underlying: Error) {
        self.underlying = underlying
    }

    public var code: Int {
        -1
    }

    public var userMessage: String {
        underlying.localizedDescription
    }

    public var errorDescription: String? {
        userMessage
    }
}

// MARK: - Auth Errors

public enum AuthError: AppErrorProtocol {
    case invalidCredentials
    case tokenExpired
    case accountLocked
    case registrationFailed

    public var code: Int {
        switch self {
        case .invalidCredentials: 3001
        case .tokenExpired: 3002
        case .accountLocked: 3003
        case .registrationFailed: 3004
        }
    }

    public var userMessage: String {
        switch self {
        case .invalidCredentials: "Invalid email or password."
        case .tokenExpired: "Session expired. Please login again."
        case .accountLocked: "Account is locked. Contact support."
        case .registrationFailed: "Registration failed. Try again."
        }
    }

    public var errorDescription: String? {
        userMessage
    }
}
