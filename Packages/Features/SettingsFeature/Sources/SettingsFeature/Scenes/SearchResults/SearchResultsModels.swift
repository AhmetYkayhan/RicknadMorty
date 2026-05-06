import AppCore
import Foundation

public enum SearchResults {
    public enum Request {
        case onAppear
        case retry
    }

    public enum Response {
        case loadingStarted
        case loaded([SearchResultEntity])
        case failed(error: any AppErrorProtocol)
    }

    public struct ViewState: ViewStateProtocol {
        public var results: [SearchResultEntity] = []
        public var isLoading: Bool = false
        public var errorMessage: String?
        public var hasSearched: Bool = false
        public init() {}
    }
}
