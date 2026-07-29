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
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            throw error
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.statusCode(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(Request.Response.self, from: data)
        } catch {
            throw APIError.decodingFailed(error.localizedDescription)
        }
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
        let response = await session.request(urlRequest).serializingData().response

        guard let httpResponse = response.response else {
            if let error = response.error {
                throw error
            }

            throw APIError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.statusCode(httpResponse.statusCode)
        }

        if let error = response.error {
            throw error
        }

        guard let data = response.data else {
            throw APIError.invalidResponse
        }

        do {
            return try decoder.decode(Request.Response.self, from: data)
        } catch {
            throw APIError.decodingFailed(error.localizedDescription)
        }
    }
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
