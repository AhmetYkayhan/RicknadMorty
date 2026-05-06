import Foundation
import HomeFeature

public enum FavoriteCharacters {
    public enum Request {
        case onAppear
        case refresh
    }

    public enum Response {
        case loaded([HomeEntity])
    }

    public struct ViewState {
        public var characters: [HomeEntity] = []
        public var isEmpty: Bool {
            characters.isEmpty
        }

        public init() {}
    }
}
