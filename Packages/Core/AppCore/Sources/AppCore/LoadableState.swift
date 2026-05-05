import Foundation

// MARK: - Generic Loadable State

public enum LoadableState<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case failed(String)

    public var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    public var value: T? {
        if case .loaded(let data) = self { return data }
        return nil
    }

    public var errorMessage: String? {
        if case .failed(let message) = self { return message }
        return nil
    }
}
