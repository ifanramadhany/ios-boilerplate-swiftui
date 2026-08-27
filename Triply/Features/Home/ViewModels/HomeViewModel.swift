import Combine
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var content = HomeContent(
        title: .pokemonTitle,
        subtitle: .pokemonSubtitle
    )
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let service: HomeService
    private let pageSize = 20

    init(service: HomeService) {
        self.service = service
    }

    func load() async {
        guard content.pokemon.isEmpty else {
            return
        }

        do {
            content = try await service.loadContent()
            await loadNextPage()
        } catch {
            content = HomeContent(
                title: .loadError,
                subtitleText: error.localizedDescription
            )
        }
    }

    func loadNextPage() async {
        guard !isLoading, content.hasMorePages else {
            return
        }

        isLoading = true
        defer {
            isLoading = false
        }

        do {
            let page = try await service.loadPokemon(
                offset: content.pokemon.count,
                limit: pageSize
            )
            content = HomeContent(
                title: content.title,
                subtitle: content.subtitle,
                subtitleText: content.subtitleText,
                pokemon: content.pokemon + page.items,
                hasMorePages: page.hasMorePages
            )
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
