import SwiftUI
import DesignSystem

// MARK: - Search Results View

struct SearchResultsView: View {
    let viewModel: SearchViewModel

    var body: some View {
        Group {
            if viewModel.isLoading && viewModel.results.isEmpty {
                LoadingView(message: "Searching...")
            } else if let error = viewModel.errorMessage, viewModel.results.isEmpty {
                ErrorView(message: error) { viewModel.search() }
            } else if viewModel.results.isEmpty {
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: SearchResultEntity.self) { result in
            destinationView(for: result)
        }
    }

    // MARK: - List

    private var resultsList: some View {
        List {
            ForEach(viewModel.results) { result in
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
        case .character(let entity): CharacterSearchRow(character: entity)
        case .episode(let entity): EpisodeSearchRow(episode: entity)
        case .location(let entity): LocationSearchRow(location: entity)
        }
    }

    @ViewBuilder
    private func destinationView(for result: SearchResultEntity) -> some View {
        switch result {
        case .character(let entity): CharacterDetailView(character: entity)
        case .episode(let entity): EpisodeDetailView(episode: entity)
        case .location(let entity): LocationDetailView(location: entity)
        }
    }
}

// MARK: - Rows

private struct CharacterSearchRow: View {
    let character: HomeEntity

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            AsyncImage(url: character.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
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
