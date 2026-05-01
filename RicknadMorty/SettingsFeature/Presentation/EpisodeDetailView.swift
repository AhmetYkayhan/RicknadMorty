import SwiftUI

// MARK: - Episode Detail View

struct EpisodeDetailView: View {
    let episode: EpisodeEntity

    var body: some View {
        Form {
            Section("Episode") {
                LabeledContent("Name", value: episode.name)
                LabeledContent("Code", value: episode.episode)
                LabeledContent("Air Date", value: episode.airDate)
            }
        }
        .navigationTitle(episode.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
