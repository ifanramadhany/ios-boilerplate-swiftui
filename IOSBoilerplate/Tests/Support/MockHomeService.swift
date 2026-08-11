import Foundation
@testable import IOSBoilerplate

final class MockHomeService: HomeService {
    let contentResult: Result<HomeContent, Error>
    private var pageResults: [Result<PokemonPage, Error>]
    private(set) var loadPokemonRequests: [PokemonPageRequest] = []

    init(
        contentResult: Result<HomeContent, Error>,
        pageResult: Result<PokemonPage, Error> = .success(PokemonPage(items: [], hasMorePages: false))
    ) {
        self.contentResult = contentResult
        pageResults = [pageResult]
    }

    init(
        contentResult: Result<HomeContent, Error>,
        pageResults: [Result<PokemonPage, Error>]
    ) {
        self.contentResult = contentResult
        self.pageResults = pageResults
    }

    func loadContent() async throws -> HomeContent {
        try contentResult.get()
    }

    func loadPokemon(offset: Int, limit: Int) async throws -> PokemonPage {
        loadPokemonRequests.append(PokemonPageRequest(offset: offset, limit: limit))

        guard !pageResults.isEmpty else {
            throw MockError.failure
        }

        return try pageResults.removeFirst().get()
    }
}

struct PokemonPageRequest: Equatable {
    let offset: Int
    let limit: Int
}
