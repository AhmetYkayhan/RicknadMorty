import Foundation

public enum Profile {
    public enum Request {
        case onAppear
        case favoritesTapped
        case consumeNavigationTrigger
    }

    public enum Response {
        case countUpdated(Int)
        case triggerFavoritesNavigation
        case clearTrigger
    }

    public struct ViewState {
        public var favoriteCount: Int = 0
        public var navigateToFavorites: Bool = false
        public init() {}
    }
}
