import Foundation

protocol HomeService {
    func loadContent() async throws -> HomeContent
    func loadPokemon(offset: Int, limit: Int) async throws -> PokemonPage
}

struct DefaultHomeService: HomeService {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func loadContent() async throws -> HomeContent {
        HomeContent(
            title: .pokemonTitle,
            subtitle: .pokemonSubtitle
        )
    }

    func loadPokemon(offset: Int, limit: Int) async throws -> PokemonPage {
        let response = try await apiClient.send(PokemonListRequest(offset: offset, limit: limit))
        let items = response.results.compactMap(PokemonCard.init(response:))

        return PokemonPage(
            items: items,
            hasMorePages: response.next != nil
        )
    }
}

struct PokemonPage: Equatable {
    let items: [PokemonCard]
    let hasMorePages: Bool
}

private struct PokemonListRequest: APIRequest {
    typealias Response = PokemonListResponse

    let path = "pokemon"
    let method: HTTPMethod = .get
    let queryItems: [URLQueryItem]

    init(offset: Int, limit: Int) {
        queryItems = [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]
    }
}

private struct PokemonListResponse: Decodable {
    let next: URL?
    let results: [PokemonListItemResponse]
}

private struct PokemonListItemResponse: Decodable {
    let name: String
    let url: URL
}

private extension PokemonCard {
    init?(response: PokemonListItemResponse) {
        guard let id = response.url.pathComponents.last.flatMap(Int.init) else {
            return nil
        }

        self.init(
            id: id,
            name: response.name,
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png")
        )
    }
}
