import SwiftUI
import DesignSystem

// MARK: - Login View

public struct LoginView: View {
    private let interactor: LoginInteractorProtocol
    @Bindable private var presenter: LoginPresenter

    public init(interactor: LoginInteractorProtocol, presenter: LoginPresenter) {
        self.interactor = interactor
        self.presenter = presenter
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.lg) {
                headerSection
                formSection
                loginButton
                forgotPasswordButton
            }
            .padding(AppSpacing.lg)
        }
        .background(AppColors.background)
    }

    // MARK: - Sections

    private var headerSection: some View {
        VStack(spacing: AppSpacing.xs) {
            Image(systemName: "person.circle.fill")
                .font(.system(size: 72))
                .foregroundColor(AppColors.accent)

            Text("Welcome Back")
                .font(AppTypography.largeTitle)
                .fontWeight(.bold)

            Text("Sign in to continue")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.secondaryLabel)
        }
        .padding(.top, AppSpacing.xxl)
    }

    @ViewBuilder
    private var emailField: some View {
        let field = AppTextField(
            placeholder: "Email",
            text: Binding(
                get: { presenter.state.email },
                set: { interactor.handle(.updateEmail($0)) }
            ),
            errorMessage: presenter.state.emailError
        )
        #if os(iOS)
        field.keyboardType(.emailAddress)
        #else
        field
        #endif
    }

    private var formSection: some View {
        VStack(spacing: AppSpacing.md) {
            emailField

            AppTextField(
                placeholder: "Password",
                text: Binding(
                    get: { presenter.state.password },
                    set: { interactor.handle(.updatePassword($0)) }
                ),
                isSecure: true,
                errorMessage: presenter.state.passwordError
            )
        }
    }

    private var loginButton: some View {
        VStack(spacing: AppSpacing.xs) {
            AppButton(
                title: "Sign In",
                isLoading: presenter.state.isLoading
            ) {
                interactor.handle(.login)
            }

            if let error = presenter.state.errorMessage {
                Text(error)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.destructive)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var forgotPasswordButton: some View {
        Button {
            interactor.handle(.forgotPassword)
        } label: {
            Text("Forgot Password?")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.accent)
        }
    }
}
