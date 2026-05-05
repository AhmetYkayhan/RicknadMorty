import SwiftUI
import DesignSystem

// MARK: - Profile View

struct ProfileView: View {
    @Environment(\.favoritesStore) private var favoritesStore

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink {
                        FavoriteCharactersView()
                    } label: {
                        HStack(spacing: AppSpacing.sm) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("Favori Karakterlerim")
                            Spacer()
                            if let count = favoritesStore?.favorites.count, count > 0 {
                                Text("\(count)")
                                    .foregroundColor(AppColors.secondaryLabel)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
