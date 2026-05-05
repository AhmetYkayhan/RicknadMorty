import SwiftUI
import DesignSystem

struct HomeListView: View {
    let interactor: HomeListInteractor
    @Bindable var presenter: HomeListPresenter

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Characters")
                .refreshable { interactor.handle(.refresh) }
        }
        .onAppear { interactor.handle(.onAppear) }
    }

    @ViewBuilder
    private var content: some View {
        if let error = presenter.viewState.errorMessage,
           presenter.viewState.characters.isEmpty {
            ErrorView(message: error) { interactor.handle(.refresh) }
        } else if presenter.viewState.isLoading,
                  presenter.viewState.characters.isEmpty {
            LoadingView(message: "Loading characters...")
        } else {
            characterList
        }
    }

    private var characterList: some View {
        List {
            ForEach(presenter.viewState.characters) { character in
                NavigationLink(value: character) {
                    CharacterRowView(character: character)
                }
                .onAppear {
                    interactor.handle(.loadMoreIfNeeded(currentItemId: character.id))
                }
            }

            if presenter.viewState.isLoading {
                HStack { Spacer(); ProgressView(); Spacer() }
                    .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: HomeEntity.self) { character in
            CharacterDetailSceneFactory.make(character: character)
        }
    }
}

struct CharacterRowView: View {
    let character: HomeEntity

    var body: some View {
        HStack(spacing: AppSpacing.sm) {
            AsyncImage(url: character.imageURL) { image in
                image.resizable().aspectRatio(contentMode: .fill)
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(width: 60, height: 60)
            .clipShape(RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: AppSpacing.xxs) {
                Text(character.name).font(AppTypography.headline)
                HStack(spacing: AppSpacing.xxs) {
                    Circle().fill(statusColor).frame(width: 8, height: 8)
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
