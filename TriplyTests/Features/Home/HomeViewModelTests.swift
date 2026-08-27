import Foundation
import Testing
@testable import Triply

@MainActor
struct HomeViewModelTests {
    @Test func loadsContentFromInjectedService() async {
        let content = HomeContent(title: .pokemonTitle, subtitle: .pokemonSubtitle, hasMorePages: false)
        let viewModel = HomeViewModel(service: MockHomeService(contentResult: .success(content)))

        await viewModel.load()

        #expect(viewModel.content == content)
    }

    @Test func loadsPokemonFromInjectedService() async {
        let pokemon = [
            PokemonCard(id: 1, name: "bulbasaur", imageURL: nil),
            PokemonCard(id: 4, name: "charmander", imageURL: nil)
        ]
        let service = MockHomeService(
            contentResult: .success(HomeContent(title: .pokemonTitle, subtitle: .pokemonSubtitle)),
            pageResult: .success(PokemonPage(items: pokemon, hasMorePages: false))
        )
        let viewModel = HomeViewModel(service: service)

        await viewModel.load()

        #expect(viewModel.content.pokemon == pokemon)
        #expect(viewModel.content.hasMorePages == false)
        #expect(viewModel.errorMessage == nil)
    }

    @Test func loadsNextPokemonPageUsingCurrentItemCount() async {
        let firstPage = [
            PokemonCard(id: 1, name: "bulbasaur", imageURL: nil),
            PokemonCard(id: 4, name: "charmander", imageURL: nil)
        ]
        let secondPage = [
            PokemonCard(id: 7, name: "squirtle", imageURL: nil)
        ]
        let service = MockHomeService(
            contentResult: .success(HomeContent(title: .pokemonTitle, subtitle: .pokemonSubtitle)),
            pageResults: [
                .success(PokemonPage(items: firstPage, hasMorePages: true)),
                .success(PokemonPage(items: secondPage, hasMorePages: false))
            ]
        )
        let viewModel = HomeViewModel(service: service)

        await viewModel.load()
        await viewModel.loadNextPage()

        #expect(service.loadPokemonRequests == [
            PokemonPageRequest(offset: 0, limit: 20),
            PokemonPageRequest(offset: 2, limit: 20)
        ])
        #expect(viewModel.content.pokemon == firstPage + secondPage)
        #expect(viewModel.content.hasMorePages == false)
    }

    @Test func showsErrorContentWhenServiceFails() async {
        let viewModel = HomeViewModel(service: MockHomeService(contentResult: .failure(MockError.failure)))

        await viewModel.load()

        #expect(viewModel.content.title == .loadError)
        #expect(viewModel.content.subtitleText == MockError.failure.localizedDescription)
    }
}
