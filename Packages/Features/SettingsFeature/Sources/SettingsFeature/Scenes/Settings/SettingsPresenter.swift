import AppCore
import Foundation
import Observation

@MainActor
@Observable
public final class SettingsPresenter {
    public private(set) var viewState = Settings.ViewState()

    public init() {}

    public func present(_ response: Settings.Response) {
        switch response {
        case let .queryChanged(value):
            viewState.query = value
        case let .typeChanged(value):
            viewState.type = value
        case .cleared:
            viewState.query = ""
        case let .triggerSearch(params):
            viewState.pendingSearch = params
        case .clearTrigger:
            viewState.pendingSearch = nil
        }
    }
}
