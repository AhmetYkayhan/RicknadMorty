import SwiftUI

// MARK: - App Colors

enum AppColors {
    static let primary = Color("PrimaryColor", bundle: .main)
    static let secondary = Color("SecondaryColor", bundle: .main)

    // Fallback semantic colors
    static let background = Color(.systemBackground)
    static let secondaryBackground = Color(.secondarySystemBackground)
    static let label = Color(.label)
    static let secondaryLabel = Color(.secondaryLabel)
    static let separator = Color(.separator)
    static let destructive = Color.red
    static let success = Color.green
    static let warning = Color.orange

    // Brand colors
    static let accent = Color.blue
    static let tint = Color.cyan
}
