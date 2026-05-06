import SwiftUI

// MARK: - App Colors

public enum AppColors {
    public static let primary = Color("PrimaryColor", bundle: .main)
    public static let secondary = Color("SecondaryColor", bundle: .main)

    // Fallback semantic colors
    #if canImport(UIKit)
        public static let background = Color(.systemBackground)
        public static let secondaryBackground = Color(.secondarySystemBackground)
        public static let label = Color(.label)
        public static let secondaryLabel = Color(.secondaryLabel)
        public static let separator = Color(.separator)
    #else
        public static let background = Color(nsColor: .windowBackgroundColor)
        public static let secondaryBackground = Color(nsColor: .controlBackgroundColor)
        public static let label = Color(nsColor: .labelColor)
        public static let secondaryLabel = Color(nsColor: .secondaryLabelColor)
        public static let separator = Color(nsColor: .separatorColor)
    #endif

    public static let destructive = Color.red
    public static let success = Color.green
    public static let warning = Color.orange

    // Brand colors
    public static let accent = Color.blue
    public static let tint = Color.cyan
}
