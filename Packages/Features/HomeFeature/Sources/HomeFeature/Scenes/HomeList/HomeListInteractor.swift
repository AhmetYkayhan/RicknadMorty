import AppCore
import Foundation
import HomeFeatureInterface

@MainActor
public final class HomeListInteractor {
    private let useCase: GetHomeUseCaseProtocol
    private let presenter: HomeListPresenter
    private weak var delegate: HomeFeatureDelegate?

    private var currentPage: Int = 1
    private var hasMore: Bool = true
    private var isFetching: Bool = false

    public init(useCase: GetHomeUseCaseProtocol,
                presenter: HomeListPresenter,
                delegate: HomeFeatureDelegate?)
    {
        self.useCase = useCase
        self.presenter = presenter
        self.delegate = delegate
    }

    public func handle(_ request: HomeList.Request) {
        switch request {
        case .onAppear:
            guard presenter.viewState.characters.isEmpty else { return }
            fetch(reset: false)

        case .refresh:
            currentPage = 1
            hasMore = true
            fetch(reset: true)

        case let .loadMoreIfNeeded(currentItemId):
            guard let last = presenter.viewState.characters.last,
                  last.id == currentItemId,
                  hasMore, !isFetching else { return }
            currentPage += 1
            fetch(reset: false)

        case let .characterTapped(id):
            delegate?.homeFeature(didSelect: .characterDetail(id: id))

        case .settingsTapped:
            delegate?.homeFeature(didSelect: .settings)
        }
    }

    private func fetch(reset: Bool) {
        guard !isFetching else { return }
        isFetching = true
        presenter.present(.loadingStarted)

        Task { [currentPage] in
            defer { isFetching = false }
            do {
                let characters = try await useCase.execute(page: currentPage)
                let more = !characters.isEmpty
                hasMore = more
                presenter.present(.pageLoaded(
                    characters: characters,
                    hasMore: more,
                    append: !reset && currentPage > 1
                ))
            } catch let error as any AppErrorProtocol {
                presenter.present(.failed(error: error))
            } catch {
                presenter.present(.failed(error: WrappedError(underlying: error)))
            }
        }
    }
}

private struct WrappedError: AppErrorProtocol {
    let underlying: Error
    var code: Int {
        -1
    }

    var userMessage: String {
        underlying.localizedDescription
    }
}
