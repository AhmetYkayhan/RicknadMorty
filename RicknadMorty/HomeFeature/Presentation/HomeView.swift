import SwiftUI

// MARK: - Home View

struct HomeView: View {
    var viewModel: HomeViewModel

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Characters")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            viewModel.settingsTapped()
                        } label: {
                            Image(systemName: "gearshape")
                        }
                    }
                }
                .refreshable {
                    viewModel.refresh()
                }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if let error = viewModel.state.errorMessage, viewModel.state.characters.isEmpty {
            ErrorView(message: error) {
                viewModel.refresh()
            }
        } else if viewModel.state.isLoading && viewModel.state.characters.isEmpty {
            LoadingView(message: "Loading characters...")
        } else {
            characterList
        }
    }

    private var characterList: some View {
        List {
            ForEach(viewModel.state.characters) { character in
                CharacterRowView(character: character)
                    .onTapGesture {
                        viewModel.characterTapped(character)
                    }
                    .onAppear {
                        viewModel.loadMoreIfNeeded(currentItem: character)
                    }
            }

            if viewModel.state.isLoading {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
    }
}

// MARK: - Character Row View

struct CharacterRowView: View {
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
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(character.name)
                    .font(AppTypography.headline)

                HStack(spacing: AppSpacing.xxs) {
                    Circle()
                        .fill(statusColor)
                        .frame(width: 8, height: 8)

                    Text("\(character.status.rawValue) - \(character.species)")
                        .font(AppTypography.caption)
                        .foregroundColor(AppColors.secondaryLabel)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(AppColors.secondaryLabel)
        }
        .padding(.vertical, AppSpacing.xxs)
    }

    private var statusColor: Color {
        switch character.status {
        case .alive: return AppColors.success
        case .dead: return AppColors.destructive
        case .unknown: return AppColors.warning
        }
    }
}

#Preview {
    let mockService = MockHomeService()
    let repository = HomeRepository(
        service: mockService,
        logger: AppLogger(category: "home-preview")
    )
    let useCase = GetHomeUseCase(repository: repository)
    let viewModel = HomeViewModel(
        getHomeUseCase: useCase,
        delegate: nil
    )

    HomeView(viewModel: viewModel)
}
