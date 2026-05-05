import Foundation
import SwiftUI
import Observation
import AppCore

// MARK: - Search ViewModel

@MainActor
@Observable
final class SearchViewModel {
    var query: String = ""
    var type: SearchType = .character

    private(set) var results: [SearchResultEntity] = []
    private(set) var isLoading: Bool = false
    private(set) var errorMessage: String?
    private(set) var hasSearched: Bool = false

    private let useCase: SearchUseCaseProtocol
    private var currentTask: Task<Void, Never>?

    init(useCase: SearchUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Intents

    func search() {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        currentTask?.cancel()
        isLoading = true
        errorMessage = nil
        hasSearched = true

        let activeType = type
        currentTask = Task { [weak self] in
            guard let self else { return }
            do {
                let items = try await self.useCase.execute(type: activeType, query: trimmed)
                if Task.isCancelled { return }
                self.results = items
            } catch {
                if Task.isCancelled { return }
                self.results = []
                self.errorMessage = (error as? any AppErrorProtocol)?.userMessage
                    ?? error.localizedDescription
            }
            self.isLoading = false
        }
    }
}
