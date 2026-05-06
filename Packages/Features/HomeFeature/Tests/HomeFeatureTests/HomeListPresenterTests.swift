import Testing
@testable import AppCore
@testable import HomeFeature

@MainActor
@Suite("HomeListPresenter")
struct HomeListPresenterTests {
    @Test("loadingStarted sets loading and clears error")
    func loading() {
        let presenter = HomeListPresenter()
        presenter.present(.loadingStarted)
        #expect(presenter.viewState.isLoading == true)
        #expect(presenter.viewState.errorMessage == nil)
    }

    @Test("pageLoaded with append=false replaces characters")
    func pageLoadedReplace() {
        let presenter = HomeListPresenter()
        let entity = HomeEntity(
            id: 1, name: "Rick", status: .alive,
            species: "Human", gender: "Male",
            origin: "Earth", location: "Earth", imageURL: nil
        )

        presenter.present(.pageLoaded(characters: [entity], hasMore: true, append: false))

        #expect(presenter.viewState.characters.count == 1)
        #expect(presenter.viewState.isLoading == false)
        #expect(presenter.viewState.hasMorePages == true)
    }

    @Test("pageLoaded with append=true grows characters")
    func pageLoadedAppend() {
        let presenter = HomeListPresenter()
        let a = HomeEntity(
            id: 1,
            name: "Rick",
            status: .alive,
            species: "Human",
            gender: "Male",
            origin: "Earth",
            location: "Earth",
            imageURL: nil
        )
        let b = HomeEntity(
            id: 2,
            name: "Morty",
            status: .alive,
            species: "Human",
            gender: "Male",
            origin: "Earth",
            location: "Earth",
            imageURL: nil
        )

        presenter.present(.pageLoaded(characters: [a], hasMore: true, append: false))
        presenter.present(.pageLoaded(characters: [b], hasMore: false, append: true))

        #expect(presenter.viewState.characters.map(\.id) == [1, 2])
        #expect(presenter.viewState.hasMorePages == false)
    }
}
