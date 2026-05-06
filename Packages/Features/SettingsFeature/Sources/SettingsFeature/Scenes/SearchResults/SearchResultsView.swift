import DesignSystem
import HomeFeature
import SwiftUI

public struct SearchResultsView: View {
    let interactor: SearchResultsInteractor
    @Bindable var presenter: SearchResultsPresenter

    @Environment(\.characterDetailFactory) private var characterDetailFactory

    public init(interactor: SearchResultsInteractor, presenter: SearchResultsPresenter) {
        self.interactor = interactor
        self.presenter = presenter
    }

    public var body: some View {
        Group {
            if presenter.viewState.isLoading, presenter.viewState.results.isEmpty {
                LoadingView(message: "Searching...")
            } else if let error = presenter.viewState.errorMessage,
                      presenter.viewState.results.isEmpty
            {
                ErrorView(message: error) { interactor.handle(.retry) }
            } else if presenter.viewState.hasSearched, presenter.viewState.results.isEmpty {
                ContentUnavailableView(
                    "Sonuç bulunamadı",
                    systemImage: "magnifyingglass",
                    description: Text("Farklı bir arama deneyin.")
                )
            } else {
                resultsList
            }
        }
        .navigationTitle("Results")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
            .navigationDestination(for: SearchResultEntity.self) { result in
                destinationView(for: result)
            }
            .onAppear { interactor.handle(.onAppear) }
    }

    private var resultsList: some View {
        List {
            ForEach(presenter.viewState.results) { result in
                NavigationLink(value: result) {
                    row(for: result)
                }
            }
        }
        .listStyle(.plain)
    }

    @ViewBuilder
    private func row(for result: SearchResultEntity) -> some View {
        switch result {
        case let .character(entity): CharacterSearchRow(character: entity)
        case let .episode(entity): EpisodeSearchRow(episode: entity)
        case let .location(entity): LocationSearchRow(location: entity)
        }
    }

    @ViewBuilder
    private func destinationView(for result: SearchResultEntity) -> some View {
        switch result {
        case let .character(entity):
            if let characterDetailFactory {
                characterDetailFactory(entity)
            } else {
                Text("CharacterDetail not configured")
            }
        case let .episode(entity):
            EpisodeDetailView(episode: entity)
        case let .location(entity):
            LocationDetailView(location: entity)
        }
    }
}

// MARK: - Rows

private struct CharacterSearchRow: View {
    let character: HomeEntity
    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            AsyncImage(url: character.imageURL) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(character.name).font(AppTypography.headline)
                Text("\(character.status.rawValue) • \(character.species)")
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.secondaryLabel)
            }
        }
        .padding(.vertical, AppSpacing.xxs)
    }
}

private struct EpisodeSearchRow: View {
    let episode: EpisodeEntity
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxs) {
            Text(episode.name).font(AppTypography.headline)
            Text("\(episode.episode) • \(episode.airDate)")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.secondaryLabel)
        }
        .padding(.vertical, AppSpacing.xxs)
    }
}

private struct LocationSearchRow: View {
    let location: LocationEntity
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxs) {
            Text(location.name).font(AppTypography.headline)
            Text("\(location.type) • \(location.dimension)")
                .font(AppTypography.caption)
                .foregroundColor(AppColors.secondaryLabel)
        }
        .padding(.vertical, AppSpacing.xxs)
    }
}
