import SwiftUI

// MARK: - Error View

public struct ErrorView: View {
    let message: String
    var retryAction: (() -> Void)?

    public init(message: String, retryAction: (() -> Void)? = nil) {
        self.message = message
        self.retryAction = retryAction
    }

    public var body: some View {
        VStack(spacing: AppSpacing.md) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 48))
                .foregroundColor(AppColors.warning)

            Text(message)
                .font(AppTypography.body)
                .foregroundColor(AppColors.secondaryLabel)
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.lg)

            if let retryAction {
                AppButton(title: "Retry", style: .primary) {
                    retryAction()
                }
                .frame(width: 160)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    ErrorView(message: "Something went wrong. Please try again.") {
        // retry
    }
}
