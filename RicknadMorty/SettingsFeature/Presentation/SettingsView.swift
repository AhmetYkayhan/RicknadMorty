import SwiftUI

// MARK: - Settings View

struct SettingsView: View {
    var onLogout: (() -> Void)?

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Button(role: .destructive) {
                        onLogout?()
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Logout")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
