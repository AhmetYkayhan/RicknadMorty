import SwiftUI

// MARK: - Episode Detail View

public struct EpisodeDetailView: View {
    let episode: EpisodeEntity

    public init(episode: EpisodeEntity) {
        self.episode = episode
    }

    public var body: some View {
        Form {
            Section("Episode") {
                LabeledContent("Name", value: episode.name)
                LabeledContent("Code", value: episode.episode)
                LabeledContent("Air Date", value: episode.airDate)
            }
        }
        .navigationTitle(episode.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}
