#if DEBUG
import Combine
import Foundation

@MainActor
final class NetworkLogStore: ObservableObject {
    static let shared = NetworkLogStore()

    @Published private(set) var entries: [NetworkLogEntry] = []

    private let maxEntries: Int
    init(maxEntries: Int = 100) {
        self.maxEntries = maxEntries
    }

    func record(
        request: URLRequest,
        statusCode: Int?,
        errorMessage: String?,
        startedAt: Date
    ) {
        let durationMilliseconds = Int(Date().timeIntervalSince(startedAt) * 1000)
        let entry = NetworkLogEntry(
            requestedAt: startedAt,
            method: request.httpMethod ?? "GET",
            url: redactedURL(from: request.url),
            statusCode: statusCode,
            durationMilliseconds: durationMilliseconds,
            requestHeaders: redactedHeaders(from: request.allHTTPHeaderFields ?? [:]),
            errorMessage: errorMessage
        )

        entries.insert(entry, at: 0)

        if entries.count > maxEntries {
            entries.removeLast(entries.count - maxEntries)
        }
    }

    func clear() {
        entries.removeAll()
    }

    private func redactedHeaders(from headers: [String: String]) -> [String: String] {
        headers.reduce(into: [:]) { result, header in
            let key = header.key
            result[key] = isSensitiveField(key) ? "<redacted>" : header.value
        }
    }

    private func isSensitiveField(_ key: String) -> Bool {
        let normalizedKey = key.lowercased().filter { $0.isLetter || $0.isNumber }
        return normalizedKey == "authorization"
            || normalizedKey.contains("cookie")
            || normalizedKey.contains("apikey")
            || normalizedKey.contains("token")
            || normalizedKey.contains("password")
            || normalizedKey.contains("secret")
            || normalizedKey.contains("email")
            || normalizedKey.contains("phone")
            || normalizedKey.contains("mobile")
            || normalizedKey == "ssn"
    }

    private func redactedURL(from url: URL?) -> URL? {
        guard let url,
              var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return url
        }

        components.queryItems = components.queryItems?.map { item in
            isSensitiveField(item.name) ? URLQueryItem(name: item.name, value: "<redacted>") : item
        }

        return components.url
    }
}
#endif
