import Alamofire
import Foundation

protocol APIClient {
    func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response
}

protocol APIRequest {
    associatedtype Response: Decodable

    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var headers: [String: String] { get }
    var body: Data? { get }
}

extension APIRequest {
    var queryItems: [URLQueryItem] {
        []
    }

    var headers: [String: String] {
        [:]
    }

    var body: Data? {
        nil
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum APIError: Error, Equatable {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingFailed(String)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "The API URL is invalid."
        case .invalidResponse:
            "The server response was invalid."
        case let .statusCode(statusCode):
            "The server returned status code \(statusCode)."
        case .decodingFailed:
            "The server response could not be read."
        }
    }
}

struct URLSessionAPIClient: APIClient {
    private let baseURL: URL
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        baseURL: URL,
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let urlRequest = try makeURLRequest(from: request, baseURL: baseURL)
        let startedAt = Date()
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            await recordNetworkLog(
                request: urlRequest,
                response: nil,
                data: nil,
                error: error,
                startedAt: startedAt
            )
            throw error
        }

        return try await decodeResponse(
            data: data,
            response: response,
            request: urlRequest,
            decoder: decoder,
            startedAt: startedAt
        )
    }
}

struct AlamofireAPIClient: APIClient {
    private let baseURL: URL
    private let session: Session
    private let decoder: JSONDecoder

    init(
        baseURL: URL,
        session: Session = .default,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }

    func send<Request: APIRequest>(_ request: Request) async throws -> Request.Response {
        let urlRequest = try makeURLRequest(from: request, baseURL: baseURL)
        let startedAt = Date()
        let response = await session.request(urlRequest).serializingData().response

        if let error = response.error {
            await recordNetworkLog(
                request: urlRequest,
                response: response.response,
                data: response.data,
                error: error,
                startedAt: startedAt
            )
            throw error
        }

        return try await decodeResponse(
            data: response.data,
            response: response.response,
            request: urlRequest,
            decoder: decoder,
            startedAt: startedAt
        )
    }
}

private func decodeResponse<Response: Decodable>(
    data: Data?,
    response: URLResponse?,
    request: URLRequest,
    decoder: JSONDecoder,
    startedAt: Date
) async throws -> Response {
    guard let httpResponse = response as? HTTPURLResponse else {
        return try await fail(
            APIError.invalidResponse,
            request: request,
            response: nil,
            data: data,
            startedAt: startedAt
        )
    }

    guard (200...299).contains(httpResponse.statusCode) else {
        return try await fail(
            APIError.statusCode(httpResponse.statusCode),
            request: request,
            response: httpResponse,
            data: data,
            startedAt: startedAt
        )
    }

    guard let data else {
        return try await fail(
            APIError.invalidResponse,
            request: request,
            response: httpResponse,
            data: nil,
            startedAt: startedAt
        )
    }

    do {
        let decodedResponse = try decoder.decode(Response.self, from: data)
        await recordNetworkLog(
            request: request,
            response: httpResponse,
            data: data,
            error: nil,
            startedAt: startedAt
        )
        return decodedResponse
    } catch {
        return try await fail(
            APIError.decodingFailed(error.localizedDescription),
            request: request,
            response: httpResponse,
            data: data,
            startedAt: startedAt
        )
    }
}

private func fail<Response>(
    _ error: Error,
    request: URLRequest,
    response: HTTPURLResponse?,
    data: Data?,
    startedAt: Date
) async throws -> Response {
    await recordNetworkLog(
        request: request,
        response: response,
        data: data,
        error: error,
        startedAt: startedAt
    )
    throw error
}

private func recordNetworkLog(
    request: URLRequest,
    response: HTTPURLResponse?,
    data: Data?,
    error: Error?,
    startedAt: Date
) async {
    #if DEBUG
    await NetworkLogStore.shared.record(
        request: request,
        statusCode: response?.statusCode,
        responseData: data,
        errorMessage: error?.localizedDescription,
        startedAt: startedAt
    )
    #endif
}

private func makeURLRequest(from request: some APIRequest, baseURL: URL) throws -> URLRequest {
    guard var components = URLComponents(
        url: baseURL.appendingPathComponent(request.path),
        resolvingAgainstBaseURL: false
    ) else {
        throw APIError.invalidURL
    }

    if !request.queryItems.isEmpty {
        components.queryItems = request.queryItems
    }

    guard let url = components.url else {
        throw APIError.invalidURL
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = request.method.rawValue
    urlRequest.httpBody = request.body
    for (key, value) in request.headers {
        urlRequest.setValue(value, forHTTPHeaderField: key)
    }

    return urlRequest
}
