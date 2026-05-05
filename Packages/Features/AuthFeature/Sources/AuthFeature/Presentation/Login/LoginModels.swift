import Foundation

// MARK: - Login Models (VIP-S)

public enum Login {

    // MARK: - Request (View -> Interactor)

    public enum Request {
        case updateEmail(String)
        case updatePassword(String)
        case login
        case forgotPassword
    }

    // MARK: - Response (Interactor -> Presenter)

    public enum Response {
        case loginLoading
        case loginSuccess
        case loginFailure(Error)
        case fieldUpdate(email: String, password: String)
    }

    // MARK: - View State (Presenter -> View)

    public struct ViewState {
        public var email: String = ""
        public var password: String = ""
        public var isLoading: Bool = false
        public var errorMessage: String? = nil
        public var isLoginSuccessful: Bool = false

        public var isFormValid: Bool {
            !email.trimmingCharacters(in: .whitespaces).isEmpty &&
            password.count >= 6
        }

        public var emailError: String? {
            guard !email.isEmpty else { return nil }
            let pattern = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
            let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
            return predicate.evaluate(with: email) ? nil : "Invalid email format"
        }

        public var passwordError: String? {
            guard !password.isEmpty else { return nil }
            return password.count < 6 ? "Password must be at least 6 characters" : nil
        }

        public init() {}
    }
}
