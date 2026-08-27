#if DEBUG
import Combine
import Foundation

@MainActor
final class NetworkLogStore: ObservableObject {
    static let shared = NetworkLogStore()

    @Published private(set) var entries: [NetworkLogEntry] = []

    private let maxEntries: Int
    private let previewLimit: Int

    init(maxEntries: Int = 100, previewLimit: Int = 4000) {
        self.maxEntries = maxEntries
        self.previewLimit = previewLimit
    }

    func record(
        request: URLRequest,
        statusCode: Int?,
        responseData: Data?,
        errorMessage: String?,
        startedAt: Date
    ) {
        let durationMilliseconds = Int(Date().timeIntervalSince(startedAt) * 1000)
        let entry = NetworkLogEntry(
            requestedAt: startedAt,
            method: request.httpMethod ?? "GET",
            url: request.url,
            statusCode: statusCode,
            durationMilliseconds: durationMilliseconds,
            requestHeaders: redactedHeaders(from: request.allHTTPHeaderFields ?? [:]),
            responsePreview: responsePreview(from: responseData),
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
            result[key] = isSensitiveHeader(key) ? "<redacted>" : header.value
        }
    }

    private func isSensitiveHeader(_ key: String) -> Bool {
        let normalizedKey = key.lowercased()
        return normalizedKey == "authorization"
            || normalizedKey == "cookie"
            || normalizedKey == "set-cookie"
            || normalizedKey == "x-api-key"
            || normalizedKey.contains("token")
    }

    private func responsePreview(from data: Data?) -> String? {
        guard let data, !data.isEmpty else {
            return nil
        }

        let object = try? JSONSerialization.jsonObject(with: data)
        let prettyPrintedData = object.flatMap {
            try? JSONSerialization.data(withJSONObject: $0, options: [.prettyPrinted, .sortedKeys])
        }
        let previewData = prettyPrintedData ?? data
        let text = String(data: previewData, encoding: .utf8) ?? "\(previewData.count) bytes"

        guard text.count > previewLimit else {
            return text
        }

        return "\(text.prefix(previewLimit))\n... truncated"
    }
}
#endif
