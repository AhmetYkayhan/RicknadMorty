import Foundation
import SettingsFeatureInterface

@MainActor
public final class SettingsInteractor {
    private let presenter: SettingsPresenter
    private weak var delegate: SettingsFeatureDelegate?

    private var query: String = ""
    private var type: SearchType = .character

    public init(presenter: SettingsPresenter,
                delegate: SettingsFeatureDelegate?) {
        self.presenter = presenter
        self.delegate = delegate
    }

    public func handle(_ request: Settings.Request) {
        switch request {
        case let .updateQuery(value):
            query = value
            presenter.present(.queryChanged(value))

        case let .updateType(value):
            type = value
            presenter.present(.typeChanged(value))

        case .clearQuery:
            query = ""
            presenter.present(.cleared)

        case .submit:
            let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }
            presenter.present(.triggerSearch(.init(query: trimmed, type: type)))

        case .logoutTapped:
            delegate?.settingsFeature(didSelect: .logout)

        case .consumeSearchTrigger:
            presenter.present(.clearTrigger)
        }
    }
}
