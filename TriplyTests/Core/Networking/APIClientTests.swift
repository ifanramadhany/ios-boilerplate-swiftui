import Foundation
import Testing
@testable import Triply

@Suite(.serialized)
struct APIClientTests {
    @Test func decodesSuccessfulResponse() async throws {
        let client = makeAPIClient { request in
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

    @Test func throwsStatusCodeError() async {
        let client = makeAPIClient { request in
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

    @Test func throwsDecodingError() async {
        let client = makeAPIClient { request in
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

    @Test func rethrowsTransportError() async {
        let client = makeAPIClient { _ in
            throw MockError.failure
        }

        do {
            _ = try await client.send(TestRequest(path: "home"))
            Issue.record("Expected transport failure")
        } catch {
            #expect(!(error is APIError))
        }
    }

    private func makeAPIClient(
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

    private static func response(statusCode: Int, request: URLRequest) throws -> HTTPURLResponse {
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
