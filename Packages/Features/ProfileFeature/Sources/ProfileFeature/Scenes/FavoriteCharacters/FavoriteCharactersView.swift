import DesignSystem
import HomeFeature
import SwiftUI

public struct FavoriteCharactersView: View {
    let interactor: FavoriteCharactersInteractor
    @Bindable var presenter: FavoriteCharactersPresenter

    @Environment(\.favoritesStore) private var favoritesStore

    public init(interactor: FavoriteCharactersInteractor, presenter: FavoriteCharactersPresenter) {
        self.interactor = interactor
        self.presenter = presenter
    }

    public var body: some View {
        Group {
            if presenter.viewState.isEmpty {
                ContentUnavailableView(
                    "Henüz favori karakter yok.",
                    systemImage: "heart"
                )
            } else {
                List {
                    ForEach(presenter.viewState.characters) { character in
                        NavigationLink(value: character) {
                            FavoriteCharacterRow(character: character)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationDestination(for: HomeEntity.self) { character in
                    CharacterDetailSceneFactory.make(character: character)
                }
            }
        }
        .navigationTitle("Favori Karakterlerim")
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
            .onAppear { interactor.handle(.onAppear) }
            .onChange(of: favoritesStore?.favorites.count ?? 0) { _, _ in
                interactor.handle(.refresh)
            }
    }
}

private struct FavoriteCharacterRow: View {
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
        }
        .padding(.vertical, AppSpacing.xxs)
    }

    private var statusColor: Color {
        switch character.status {
        case .alive: AppColors.success
        case .dead: AppColors.destructive
        case .unknown: AppColors.warning
        }
    }
}
