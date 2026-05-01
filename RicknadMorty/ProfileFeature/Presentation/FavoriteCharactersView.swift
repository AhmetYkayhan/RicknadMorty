import SwiftUI

// MARK: - Favorite Characters View

struct FavoriteCharactersView: View {
    @Environment(\.favoritesStore) private var favoritesStore

    var body: some View {
        Group {
            if let store = favoritesStore, !store.favorites.isEmpty {
                List {
                    ForEach(store.favorites) { character in
                        NavigationLink(value: character) {
                            FavoriteCharacterRow(character: character)
                        }
                    }
                }
                .listStyle(.plain)
                .navigationDestination(for: HomeEntity.self) { character in
                    CharacterDetailView(character: character)
                }
            } else {
                ContentUnavailableView(
                    "Henüz favori karakter yok.",
                    systemImage: "heart"
                )
            }
        }
        .navigationTitle("Favori Karakterlerim")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Row

private struct FavoriteCharacterRow: View {
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
