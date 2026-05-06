import SwiftUI

// MARK: - Location Detail View

public struct LocationDetailView: View {
    let location: LocationEntity

    public init(location: LocationEntity) {
        self.location = location
    }

    public var body: some View {
        Form {
            Section("Location") {
                LabeledContent("Name", value: location.name)
                LabeledContent("Type", value: location.type)
                LabeledContent("Dimension", value: location.dimension)
            }
        }
        .navigationTitle(location.name)
        #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}
