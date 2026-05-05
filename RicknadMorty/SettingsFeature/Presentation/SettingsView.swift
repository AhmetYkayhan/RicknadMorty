import SwiftUI
import DesignSystem

// MARK: - Settings View

struct SettingsView: View {
    @Bindable var viewModel: SearchViewModel
    var onLogout: (() -> Void)?

    @State private var showResults = false

    var body: some View {
        NavigationStack {
            List {
                Section("Search") {
                    Picker("Type", selection: $viewModel.type) {
                        ForEach(SearchType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)

                    HStack(spacing: AppSpacing.xs) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(AppColors.secondaryLabel)

                        TextField("Search...", text: $viewModel.query)
                            .submitLabel(.search)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .onSubmit(performSearch)

                        if !viewModel.query.isEmpty {
                            Button {
                                viewModel.query = ""
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
                        onLogout?()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Logout")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationDestination(isPresented: $showResults) {
                SearchResultsView(viewModel: viewModel)
            }
        }
    }

    private func performSearch() {
        let trimmed = viewModel.query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        viewModel.search()
        showResults = true
    }
}
