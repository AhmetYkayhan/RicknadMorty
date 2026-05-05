import SwiftUI
import HomeFeatureInterface

// MARK: - Home Feature Assembly

/// Concrete implementation of HomeFeatureInterface.
/// AppShell creates this and injects dependencies.
final class HomeFeatureAssembly: HomeFeatureInterface {
    private let getHomeUseCase: GetHomeUseCaseProtocol
    private weak var delegate: HomeFeatureDelegate?

    init(getHomeUseCase: GetHomeUseCaseProtocol,
         delegate: HomeFeatureDelegate?) {
        self.getHomeUseCase = getHomeUseCase
        self.delegate = delegate
    }

    @MainActor
    func makeHomeView() -> AnyView {
        let viewModel = HomeViewModel(
            getHomeUseCase: getHomeUseCase,
            delegate: delegate
        )
        return AnyView(HomeView(viewModel: viewModel))
    }
}
