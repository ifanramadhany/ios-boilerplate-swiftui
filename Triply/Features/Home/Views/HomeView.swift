import SwiftUI

struct HomeView: View {
    let service: HomeService

    var body: some View {
        ContentView(service: service)
    }
}

#Preview {
    HomeView(service: PreviewHomeService())
}

private struct PreviewHomeService: HomeService {
    func loadContent() async throws -> HomeContent {
        HomeContent(
            title: .pokemonTitle,
            subtitle: .pokemonSubtitle,
            pokemon: [],
            hasMorePages: false
        )
    }

    func loadPokemon(offset: Int, limit: Int) async throws -> PokemonPage {
        PokemonPage(items: [], hasMorePages: false)
    }
}
