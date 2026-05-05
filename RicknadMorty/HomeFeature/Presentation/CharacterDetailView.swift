import SwiftUI
import DesignSystem

// MARK: - Character Detail View

struct CharacterDetailView: View {
    let character: HomeEntity

    @Environment(\.favoritesStore) private var favoritesStore

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                // Character Image
                AsyncImage(url: character.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.gray.opacity(0.3)
                        .aspectRatio(1, contentMode: .fit)
                }
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, AppSpacing.md)

                // Info Section
                VStack(spacing: AppSpacing.xs) {
                    infoRow(label: "Status", value: character.status.rawValue, color: statusColor)
                    infoRow(label: "Species", value: character.species)
                    infoRow(label: "Gender", value: character.gender)
                    infoRow(label: "Origin", value: character.origin)
                    infoRow(label: "Location", value: character.location)
                }
                .padding(.horizontal, AppSpacing.md)
            }
            .padding(.bottom, AppSpacing.lg)
        }
        .navigationTitle(character.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            if let store = favoritesStore {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        store.toggle(character)
                    } label: {
                        Image(systemName: store.isFavorite(character.id) ? "heart.fill" : "heart")
                            .foregroundColor(store.isFavorite(character.id) ? .red : AppColors.secondaryLabel)
                    }
                }
            }
        }
    }

    // MARK: - Info Row

    private func infoRow(label: String, value: String, color: Color? = nil) -> some View {
        HStack {
            Text(label)
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.secondaryLabel)

            Spacer()

            HStack(spacing: AppSpacing.xxs) {
                if let color {
                    Circle()
                        .fill(color)
                        .frame(width: 8, height: 8)
                }
                Text(value)
                    .font(AppTypography.body)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }

    private var statusColor: Color {
        switch character.status {
        case .alive: return AppColors.success
        case .dead: return AppColors.destructive
        case .unknown: return AppColors.warning
        }
    }
}
