import Foundation

// MARK: - Home View State

struct HomeViewState: ViewStateProtocol {
    var characters: [HomeEntity] = []
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var currentPage: Int = 1
    var hasMorePages: Bool = true
}
