#if DEBUG
import Foundation
import Testing
@testable import Triply

@MainActor
struct NetworkLogStoreTests {
    @Test func redactsSensitiveHeaders() {
        let store = NetworkLogStore()
        var request = URLRequest(url: URL(string: "https://api.example.test/home") ?? URL(fileURLWithPath: "/"))
        request.httpMethod = "GET"
        request.setValue("Bearer secret", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        store.record(
            request: request,
            statusCode: 200,
            responseData: Data("{\"message\":\"Ready\"}".utf8),
            errorMessage: nil,
            startedAt: Date()
        )

        #expect(store.entries.count == 1)
        #expect(store.entries[0].requestHeaders["Authorization"] == "<redacted>")
        #expect(store.entries[0].requestHeaders["Accept"] == "application/json")
        #expect(store.entries[0].responsePreview?.contains("\"message\"") == true)
    }
}
#endif
