import AppLogger
import AppNetwork
import SettingsFeatureInterface
import SwiftUI

// MARK: - Settings Feature Assembly

public final class SettingsFeatureAssembly: SettingsFeatureInterface {
    private let networkClient: NetworkClientProtocol
    private let logger: LoggerProtocol
    private weak var delegate: SettingsFeatureDelegate?

    public init(networkClient: NetworkClientProtocol,
                logger: LoggerProtocol,
                delegate: SettingsFeatureDelegate?)
    {
        self.networkClient = networkClient
        self.logger = logger
        self.delegate = delegate
    }

    // MARK: - Concrete Scene Factory

    @MainActor
    public func makeSettingsScene() -> SettingsView {
        SearchResultsSceneFactory.shared = SearchResultsSceneFactory(
            networkClient: networkClient,
            logger: logger
        )

        let presenter = SettingsPresenter()
        let interactor = SettingsInteractor(presenter: presenter, delegate: delegate)
        return SettingsView(interactor: interactor, presenter: presenter)
    }

    // MARK: - SettingsFeatureInterface

    @MainActor
    public func makeSettingsView() -> AnyView {
        AnyView(makeSettingsScene())
    }
}
