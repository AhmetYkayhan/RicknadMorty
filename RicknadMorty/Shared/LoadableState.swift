import Foundation

// MARK: - Generic Loadable State

enum LoadableState<T: Equatable>: Equatable {
    case idle
    case loading
    case loaded(T)
    case failed(String)

    var isLoading: Bool {
        if case .loading = self { return true }
        return false
    }

    var value: T? {
        if case .loaded(let data) = self { return data }
        return nil
    }

    var errorMessage: String? {
        if case .failed(let message) = self { return message }
        return nil
    }
}
