import AppCore
import Foundation

public enum Settings {
    public struct SearchParams: Equatable, Hashable {
        public let query: String
        public let type: SearchType

        public init(query: String, type: SearchType) {
            self.query = query
            self.type = type
        }
    }

    public enum Request {
        case updateQuery(String)
        case updateType(SearchType)
        case clearQuery
        case submit
        case logoutTapped
        case consumeSearchTrigger
    }

    public enum Response {
        case queryChanged(String)
        case typeChanged(SearchType)
        case cleared
        case triggerSearch(SearchParams)
        case clearTrigger
    }

    public struct ViewState: ViewStateProtocol {
        public var query: String = ""
        public var type: SearchType = .character
        public var pendingSearch: SearchParams?

        public var isLoading: Bool {
            false
        }

        public var errorMessage: String? {
            nil
        }

        public init() {}
    }
}
