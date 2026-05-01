import SwiftUI

// MARK: - Location Detail View

struct LocationDetailView: View {
    let location: LocationEntity

    var body: some View {
        Form {
            Section("Location") {
                LabeledContent("Name", value: location.name)
                LabeledContent("Type", value: location.type)
                LabeledContent("Dimension", value: location.dimension)
            }
        }
        .navigationTitle(location.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
