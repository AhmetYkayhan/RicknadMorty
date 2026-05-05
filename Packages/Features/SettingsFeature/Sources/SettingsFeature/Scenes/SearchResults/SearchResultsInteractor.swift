import Foundation
import AppCore

@MainActor
public final class SearchResultsInteractor {
    private let useCase: SearchUseCaseProtocol
    private let presenter: SearchResultsPresenter
    private let params: Settings.SearchParams

    private var currentTask: Task<Void, Never>?

    public init(useCase: SearchUseCaseProtocol,
                presenter: SearchResultsPresenter,
                params: Settings.SearchParams) {
        self.useCase = useCase
        self.presenter = presenter
        self.params = params
    }

    public func handle(_ request: SearchResults.Request) {
        switch request {
        case .onAppear:
            guard !presenter.viewState.hasSearched else { return }
            search()
        case .retry:
            search()
        }
    }

    private func search() {
        currentTask?.cancel()
        presenter.present(.loadingStarted)

        currentTask = Task { [weak self] in
            guard let self else { return }
            do {
                let items = try await self.useCase.execute(type: self.params.type, query: self.params.query)
                if Task.isCancelled { return }
                self.presenter.present(.loaded(items))
            } catch let error as any AppErrorProtocol {
                if Task.isCancelled { return }
                self.presenter.present(.failed(error: error))
            } catch {
                if Task.isCancelled { return }
                self.presenter.present(.failed(error: WrappedError(underlying: error)))
            }
        }
    }
}

private struct WrappedError: AppErrorProtocol {
    let underlying: Error
    var code: Int { -1 }
    var userMessage: String { underlying.localizedDescription }
}
