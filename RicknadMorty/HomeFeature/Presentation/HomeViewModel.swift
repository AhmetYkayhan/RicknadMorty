import Foundation
import SwiftUI
import Observation

// MARK: - Home ViewModel

@MainActor
@Observable
final class HomeViewModel {
    private(set) var state = HomeViewState()

    private let getHomeUseCase: GetHomeUseCaseProtocol
    private weak var delegate: HomeFeatureDelegate?

    init(getHomeUseCase: GetHomeUseCaseProtocol,
         delegate: HomeFeatureDelegate?) {
        self.getHomeUseCase = getHomeUseCase
        self.delegate = delegate
    }

    // MARK: - Intents

    func onAppear() {
        guard state.characters.isEmpty else { return }
        loadCharacters()
    }

    func refresh() {
        state.currentPage = 1
        state.characters = []
        state.hasMorePages = true
        loadCharacters()
    }

    func loadMoreIfNeeded(currentItem: HomeEntity) {
        guard let lastItem = state.characters.last,
              lastItem.id == currentItem.id,
              state.hasMorePages,
              !state.isLoading else { return }

        state.currentPage += 1
        loadCharacters()
    }

    func characterTapped(_ character: HomeEntity) {
        delegate?.homeFeature(didSelect: .characterDetail(id: character.id))
    }

    func settingsTapped() {
        delegate?.homeFeature(didSelect: .settings)
    }

    // MARK: - Private

    private func loadCharacters() {
        state.isLoading = true
        state.errorMessage = nil

        Task {
            do {
                let characters = try await getHomeUseCase.execute(page: state.currentPage)
                state.characters.append(contentsOf: characters)
                state.hasMorePages = !characters.isEmpty
                state.isLoading = false
            } catch {
                state.isLoading = false
                state.errorMessage = (error as? any AppErrorProtocol)?.userMessage
                    ?? error.localizedDescription
            }
        }
    }
}
