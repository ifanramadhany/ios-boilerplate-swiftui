//
//  IOSBoilerplateTests.swift
//  IOSBoilerplateTests
//
//  Created by Ifan Ramadhany on 19/06/2026.
//

import Foundation
import Testing
@testable import IOSBoilerplate

@Suite(.serialized)
struct IOSBoilerplateTests {
    @Test func trimmedRemovesWhitespaceAndNewlines() {
        #expect("  Hello\n".trimmed == "Hello")
    }

    @Test func appAppearanceMapsToColorScheme() {
        #expect(AppAppearance.system.colorScheme == nil)
        #expect(AppAppearance.light.colorScheme != nil)
        #expect(AppAppearance.dark.colorScheme != nil)
    }

    @Test func appLanguageMapsToLocale() {
        #expect(AppLanguage.english.locale.identifier == "en")
        #expect(AppLanguage.indonesian.locale.identifier == "id")
    }

    @Test func appEnvironmentReadsKnownValueFromInfoDictionary() {
        let environment = AppEnvironment.current(from: ["APP_ENVIRONMENT": "production"])

        #expect(environment == .production)
    }

    @Test func appEnvironmentFallsBackToDevelopmentForUnknownValue() {
        let environment = AppEnvironment.current(from: ["APP_ENVIRONMENT": "unknown"])

        #expect(environment == .development)
    }

    @Test func appEnvironmentReadsBaseURLFromInfoDictionary() {
        let baseURL = AppEnvironment.baseURL(from: ["API_BASE_URL": "https://api.example.test"])

        #expect(baseURL.absoluteString == "https://api.example.test")
    }

    @Test func appEnvironmentFallsBackToDefaultBaseURL() {
        let baseURL = AppEnvironment.baseURL(from: ["API_BASE_URL": ""])

        #expect(baseURL == AppEnvironment.defaultBaseURL)
    }

    @Test func apiClientDecodesSuccessfulResponse() async throws {
        let client = Self.makeAPIClient { request in
            #expect(request.url?.absoluteString == "https://api.example.test/home?limit=20")

            let response = try Self.response(statusCode: 200, request: request)
            let data = try JSONEncoder().encode(TestResponse(message: "Ready"))

            return (response, data)
        }

        let response = try await client.send(TestRequest(path: "home", queryItems: [
            URLQueryItem(name: "limit", value: "20")
        ]))

        #expect(response == TestResponse(message: "Ready"))
    }

    @Test func apiClientThrowsStatusCodeError() async {
        let client = Self.makeAPIClient { request in
            let response = try Self.response(statusCode: 500, request: request)

            return (response, Data())
        }

        do {
            _ = try await client.send(TestRequest(path: "home"))
            Issue.record("Expected APIError.statusCode")
        } catch let error as APIError {
            #expect(error == .statusCode(500))
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test func apiClientThrowsDecodingError() async {
        let client = Self.makeAPIClient { request in
            let response = try Self.response(statusCode: 200, request: request)

            return (response, Data("invalid-json".utf8))
        }

        do {
            _ = try await client.send(TestRequest(path: "home"))
            Issue.record("Expected APIError.decodingFailed")
        } catch let error as APIError {
            guard case let .decodingFailed(message) = error else {
                Issue.record("Unexpected API error: \(error)")
                return
            }

            #expect(!message.isEmpty)
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test func apiClientRethrowsTransportError() async {
        let client = Self.makeAPIClient { _ in
            throw MockError.failure
        }

        do {
            _ = try await client.send(TestRequest(path: "home"))
            Issue.record("Expected transport failure")
        } catch {
            #expect(!(error is APIError))
        }
    }

    @MainActor
    @Test func homeViewModelLoadsContentFromInjectedService() async {
        let content = HomeContent(title: .pokemonTitle, subtitle: .pokemonSubtitle, hasMorePages: false)
        let viewModel = HomeViewModel(service: MockHomeService(contentResult: .success(content)))

        await viewModel.load()

        #expect(viewModel.content == content)
    }

    @MainActor
    @Test func homeViewModelLoadsPokemonFromInjectedService() async {
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

    @MainActor
    @Test func homeViewModelLoadsNextPokemonPageUsingCurrentItemCount() async {
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

    @MainActor
    @Test func homeViewModelShowsErrorContentWhenServiceFails() async {
        let viewModel = HomeViewModel(service: MockHomeService(contentResult: .failure(MockError.failure)))

        await viewModel.load()

        #expect(viewModel.content.title == .loadError)
        #expect(viewModel.content.subtitleText == MockError.failure.localizedDescription)
    }

    @MainActor
    @Test func settingsViewModelLoadsItemsFromInjectedService() async {
        let items = [
            SettingsItem(id: "theme", title: .theme, subtitle: .systemAppearance)
        ]
        let viewModel = SettingsViewModel(service: MockSettingsService(result: .success(items)))

        await viewModel.load()

        #expect(viewModel.items == items)
    }
}

private final class MockHomeService: HomeService {
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

private struct PokemonPageRequest: Equatable {
    let offset: Int
    let limit: Int
}

private struct MockSettingsService: SettingsService {
    let result: Result<[SettingsItem], Error>

    func loadItems() async throws -> [SettingsItem] {
        try result.get()
    }
}

private enum MockError: Error, Equatable {
    case failure
}

private struct TestRequest: APIRequest {
    typealias Response = TestResponse

    let path: String
    let method: HTTPMethod = .get
    let queryItems: [URLQueryItem]

    init(path: String, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.queryItems = queryItems
    }
}

private struct TestResponse: Codable, Equatable {
    let message: String
}

private extension IOSBoilerplateTests {
    static func makeAPIClient(
        handler: @escaping @Sendable (URLRequest) throws -> (HTTPURLResponse, Data)
    ) -> URLSessionAPIClient {
        MockURLProtocol.requestHandler = handler

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]

        return URLSessionAPIClient(
            baseURL: URL(string: "https://api.example.test") ?? URL(fileURLWithPath: "/"),
            session: URLSession(configuration: configuration)
        )
    }

    static func response(statusCode: Int, request: URLRequest) throws -> HTTPURLResponse {
        guard
            let url = request.url,
            let response = HTTPURLResponse(
                url: url,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )
        else {
            throw MockError.failure
        }

        return response
    }
}

private final class MockURLProtocol: URLProtocol {
    nonisolated(unsafe) static var requestHandler: (@Sendable (URLRequest) throws -> (HTTPURLResponse, Data))?

    override static func canInit(with request: URLRequest) -> Bool {
        true
    }

    override static func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let requestHandler = Self.requestHandler else {
            client?.urlProtocol(self, didFailWithError: MockError.failure)
            return
        }

        do {
            let (response, data) = try requestHandler(request)

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
