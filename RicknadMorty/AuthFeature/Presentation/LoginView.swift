import SwiftUI

// MARK: - Login View

struct LoginView: View {
    var viewModel: LoginViewModel

    var body: some View {
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

    private var formSection: some View {
        VStack(spacing: AppSpacing.md) {
            AppTextField(
                placeholder: "Email",
                text: Binding(
                    get: { viewModel.state.email },
                    set: { viewModel.updateEmail($0) }
                ),
                errorMessage: viewModel.state.emailError
            )
            .keyboardType(.emailAddress)

            AppTextField(
                placeholder: "Password",
                text: Binding(
                    get: { viewModel.state.password },
                    set: { viewModel.updatePassword($0) }
                ),
                isSecure: true,
                errorMessage: viewModel.state.passwordError
            )
        }
    }

    private var loginButton: some View {
        VStack(spacing: AppSpacing.xs) {
            AppButton(
                title: "Sign In",
                isLoading: viewModel.state.isLoading
            ) {
                viewModel.login()
            }

            if let error = viewModel.state.errorMessage {
                Text(error)
                    .font(AppTypography.caption)
                    .foregroundColor(AppColors.destructive)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var forgotPasswordButton: some View {
        Button {
            viewModel.forgotPasswordTapped()
        } label: {
            Text("Forgot Password?")
                .font(AppTypography.subheadline)
                .foregroundColor(AppColors.accent)
        }
    }
}

#Preview {
    let mockService = MockAuthService()
    let mockStorage = MockTokenStorage()
    let repository = AuthRepository(
        service: mockService,
        logger: AppLogger(category: "auth-preview")
    )
    let useCase = LoginUseCase(
        repository: repository,
        tokenStorage: mockStorage
    )
    let viewModel = LoginViewModel(
        loginUseCase: useCase,
        delegate: nil
    )

    LoginView(viewModel: viewModel)
}
