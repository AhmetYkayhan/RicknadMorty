import SwiftUI

// MARK: - App Text Field

public struct AppTextField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure: Bool
    var errorMessage: String?

    public init(placeholder: String,
                text: Binding<String>,
                isSecure: Bool = false,
                errorMessage: String? = nil) {
        self.placeholder = placeholder
        self._text = text
        self.isSecure = isSecure
        self.errorMessage = errorMessage
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.xxs) {
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .padding(AppSpacing.sm)
            .background(AppColors.secondaryBackground)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(borderColor, lineWidth: 1)
            )
            .autocorrectionDisabled()
            #if canImport(UIKit)
            .textInputAutocapitalization(.never)
            #endif

            if let errorMessage {
                Text(errorMessage)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.destructive)
            }
        }
    }

    private var borderColor: Color {
        errorMessage != nil ? AppColors.destructive : AppColors.separator
    }
}

#Preview {
    VStack(spacing: AppSpacing.md) {
        AppTextField(placeholder: "Email", text: .constant(""))
        AppTextField(placeholder: "Password", text: .constant(""), isSecure: true)
        AppTextField(placeholder: "Email", text: .constant("bad"), errorMessage: "Invalid email")
    }
    .padding()
}
