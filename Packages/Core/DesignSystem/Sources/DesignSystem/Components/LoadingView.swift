import SwiftUI

// MARK: - Loading View

public struct LoadingView: View {
    var message: String?

    public init(message: String? = nil) {
        self.message = message
    }

    public var body: some View {
        VStack(spacing: AppSpacing.md) {
            ProgressView()
                .controlSize(.large)

            if let message {
                Text(message)
                    .font(AppTypography.subheadline)
                    .foregroundColor(AppColors.secondaryLabel)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView(message: "Loading...")
}
