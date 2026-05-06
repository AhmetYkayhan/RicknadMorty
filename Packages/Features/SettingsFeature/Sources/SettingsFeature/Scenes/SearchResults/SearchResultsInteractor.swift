import AppCore
import Foundation

@MainActor
public final class SearchResultsInteractor {
    private let useCase: SearchUseCaseProtocol
    private let presenter: SearchResultsPresenter
    private let params: Settings.SearchParams

    private var currentTask: Task<Void, Never>?

    public init(useCase: SearchUseCaseProtocol,
                presenter: SearchResultsPresenter,
                params: Settings.SearchParams)
    {
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
                let items = try await useCase.execute(type: params.type, query: params.query)
                if Task.isCancelled { return }
                presenter.present(.loaded(items))
            } catch let error as any AppErrorProtocol {
                if Task.isCancelled { return }
                self.presenter.present(.failed(error: error))
            } catch {
                if Task.isCancelled { return }
                presenter.present(.failed(error: GenericAppError(error)))
            }
        }
    }
}
