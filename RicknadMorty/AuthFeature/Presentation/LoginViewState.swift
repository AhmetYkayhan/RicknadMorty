import Foundation

// MARK: - Login View State

struct LoginViewState: ViewStateProtocol {
    var email: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var isLoginSuccessful: Bool = false

    // Validation
    var isFormValid: Bool {
        !email.trimmingCharacters(in: .whitespaces).isEmpty &&
        password.count >= 6
    }

    var emailError: String? {
        guard !email.isEmpty else { return nil }
        let emailRegex = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/
        return email.wholeMatch(of: emailRegex) == nil ? "Invalid email format" : nil
    }

    var passwordError: String? {
        guard !password.isEmpty else { return nil }
        return password.count < 6 ? "Password must be at least 6 characters" : nil
    }
}
