import AppCore
import Foundation

public enum HomeList {
    public enum Request {
        case onAppear
        case refresh
        case loadMoreIfNeeded(currentItemId: Int)
        case characterTapped(id: Int)
        case settingsTapped
    }

    public enum Response {
        case loadingStarted
        case pageLoaded(characters: [HomeEntity], hasMore: Bool, append: Bool)
        case failed(error: any AppErrorProtocol)
    }

    public struct ViewState: ViewStateProtocol {
        public var characters: [HomeEntity] = []
        public var isLoading: Bool = false
        public var errorMessage: String?
        public var hasMorePages: Bool = true

        public init() {}
    }
}
