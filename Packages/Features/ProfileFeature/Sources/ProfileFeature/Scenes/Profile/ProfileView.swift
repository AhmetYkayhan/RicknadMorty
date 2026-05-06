import SwiftUI
import DesignSystem
import HomeFeature

struct ProfileView: View {
    let interactor: ProfileInteractor
    @Bindable var presenter: ProfilePresenter

    @Environment(\.favoritesStore) private var favoritesStore

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button {
                        interactor.handle(.favoritesTapped)
                    } label: {
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: "heart.fill").foregroundColor(.red)
                            Text("Favori Karakterlerim")
                                .foregroundColor(.primary)
                            Spacer()
                            if presenter.viewState.favoriteCount > 0 {
                                Text("\(presenter.viewState.favoriteCount)")
                                    .foregroundColor(AppColors.secondaryLabel)
                            }
                            Image(systemName: "chevron.right")
                                .foregroundColor(AppColors.secondaryLabel)
                        }
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationDestination(
                isPresented: Binding(
                    get: { presenter.viewState.navigateToFavorites },
                    set: { newValue in
                        if !newValue { interactor.handle(.consumeNavigationTrigger) }
                    }
                )
            ) {
                FavoriteCharactersSceneFactory.make()
            }
        }
        .onAppear { interactor.handle(.onAppear) }
        .onChange(of: favoritesStore?.favorites.count ?? 0) { _, _ in
            interactor.handle(.onAppear)
        }
    }
}
