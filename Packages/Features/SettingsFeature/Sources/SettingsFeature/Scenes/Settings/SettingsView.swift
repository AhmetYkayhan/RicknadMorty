import SwiftUI
import DesignSystem

struct SettingsView: View {
    let interactor: SettingsInteractor
    @Bindable var presenter: SettingsPresenter

    var body: some View {
        NavigationStack {
            List {
                Section("Search") {
                    Picker("Type", selection: typeBinding) {
                        ForEach(SearchType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)

                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppColors.secondaryLabel)

                        TextField("Search...", text: queryBinding)
                            .submitLabel(.search)
                            .modifier(NoCapitalizationModifier())
                            .autocorrectionDisabled()
                            .onSubmit { interactor.handle(.submit) }

                        if !presenter.viewState.query.isEmpty {
                            Button {
                                interactor.handle(.clearQuery)
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(AppColors.secondaryLabel)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                Section {
                    Button(role: .destructive) {
                        interactor.handle(.logoutTapped)
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Logout")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationDestination(item: pendingSearchBinding) { params in
                SearchResultsSceneFactory.make(params: params)
            }
        }
    }

    private var queryBinding: Binding<String> {
        Binding(
            get: { presenter.viewState.query },
            set: { interactor.handle(.updateQuery($0)) }
        )
    }

    private var typeBinding: Binding<SearchType> {
        Binding(
            get: { presenter.viewState.type },
            set: { interactor.handle(.updateType($0)) }
        )
    }

    private var pendingSearchBinding: Binding<Settings.SearchParams?> {
        Binding(
            get: { presenter.viewState.pendingSearch },
            set: { newValue in
                if newValue == nil {
                    interactor.handle(.consumeSearchTrigger)
                }
            }
        )
    }
}

// MARK: - Cross-platform helpers

private struct NoCapitalizationModifier: ViewModifier {
    func body(content: Content) -> some View {
        #if os(iOS)
        content.textInputAutocapitalization(.never)
        #else
        content
        #endif
    }
}
