import SwiftUI

// MARK: - App Button

public struct AppButton: View {
    let title: String
    let style: Style
    let isLoading: Bool
    let action: () -> Void

    public enum Style {
        case primary
        case secondary
        case destructive
    }

    public init(title: String,
                style: Style = .primary,
                isLoading: Bool = false,
                action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.isLoading = isLoading
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                Text(title)
                    .font(AppTypography.headline)
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .foregroundColor(foregroundColor)
            .background(backgroundColor)
            .cornerRadius(12)
        }
        .disabled(isLoading)
        .opacity(isLoading ? 0.8 : 1.0)
    }

    private var backgroundColor: Color {
        switch style {
        case .primary: return AppColors.accent
        case .secondary: return AppColors.secondaryBackground
        case .destructive: return AppColors.destructive
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary: return .white
        case .secondary: return AppColors.label
        case .destructive: return .white
        }
    }
}

#Preview {
    VStack(spacing: AppSpacing.md) {
        AppButton(title: "Login", style: .primary) {}
        AppButton(title: "Cancel", style: .secondary) {}
        AppButton(title: "Delete", style: .destructive) {}
        AppButton(title: "Loading...", isLoading: true) {}
    }
    .padding()
}
