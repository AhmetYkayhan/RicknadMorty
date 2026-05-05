import SwiftUI
import DesignSystem

struct CharacterDetailView: View {
    let interactor: CharacterDetailInteractor
    @Bindable var presenter: CharacterDetailPresenter

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.md) {
                if let character = presenter.viewState.character {
                    AsyncImage(url: character.imageURL) { image in
                        image.resizable().aspectRatio(contentMode: .fit)
                    } placeholder: {
                        Color.gray.opacity(0.3).aspectRatio(1, contentMode: .fit)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .padding(.horizontal, AppSpacing.md)

                    VStack(spacing: AppSpacing.xs) {
                        infoRow(label: "Status", value: character.status.rawValue, color: statusColor(for: character))
                        infoRow(label: "Species", value: character.species)
                        infoRow(label: "Gender", value: character.gender)
                        infoRow(label: "Origin", value: character.origin)
                        infoRow(label: "Location", value: character.location)
                    }
                    .padding(.horizontal, AppSpacing.md)
                }
            }
            .padding(.bottom, AppSpacing.lg)
        }
        .navigationTitle(presenter.viewState.character?.name ?? "")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.large)
        #endif
        .toolbar {
            ToolbarItem(placement: toolbarTrailingPlacement) {
                Button {
                    interactor.handle(.toggleFavorite)
                } label: {
                    Image(systemName: presenter.viewState.isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(presenter.viewState.isFavorite ? .red : AppColors.secondaryLabel)
                }
            }
        }
        .onAppear { interactor.handle(.onAppear) }
    }

    private var toolbarTrailingPlacement: ToolbarItemPlacement {
        #if os(iOS)
        .topBarTrailing
        #else
        .automatic
        #endif
    }

    private func infoRow(label: String, value: String, color: Color? = nil) -> some View {
        HStack {
            Text(label)
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.secondaryLabel)
            Spacer()
            HStack(spacing: AppSpacing.xxs) {
                if let color {
                    Circle().fill(color).frame(width: 8, height: 8)
                }
                Text(value).font(AppTypography.body)
            }
        }
        .padding(.vertical, AppSpacing.xs)
    }

    private func statusColor(for character: HomeEntity) -> Color {
        switch character.status {
        case .alive: return AppColors.success
        case .dead: return AppColors.destructive
        case .unknown: return AppColors.warning
        }
    }
}
