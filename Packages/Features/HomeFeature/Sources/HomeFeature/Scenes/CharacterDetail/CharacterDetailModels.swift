import Foundation

public enum CharacterDetail {

    public enum Request {
        case onAppear
        case toggleFavorite
    }

    public enum Response {
        case loaded(character: HomeEntity, isFavorite: Bool)
        case favoriteChanged(isFavorite: Bool)
    }

    public struct ViewState {
        public var character: HomeEntity?
        public var isFavorite: Bool = false
        public init() {}
    }
}
