import SwiftUI

// MARK: - Profile View

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: AppSpacing.lg) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(AppColors.secondaryLabel)

                Text("Profile")
                    .font(AppTypography.title2)

                Text("Coming soon")
                    .font(AppTypography.subheadline)
                    .foregroundColor(AppColors.secondaryLabel)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(AppColors.background)
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
