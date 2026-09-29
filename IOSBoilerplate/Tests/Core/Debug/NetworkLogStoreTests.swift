#if DEBUG
import Foundation
import Testing
@testable import IOSBoilerplate

@MainActor
struct NetworkLogStoreTests {
    @Test func redactsSensitiveHeadersAndQueryValues() {
        let store = NetworkLogStore()
        var request = URLRequest(
            url: URL(string: "https://api.example.test/home?access_token=secret&sort=recent")
                ?? URL(fileURLWithPath: "/")
        )
        request.httpMethod = "GET"
        request.setValue("Bearer secret", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        store.record(
            request: request,
            statusCode: 200,
            errorMessage: nil,
            startedAt: Date()
        )

        #expect(store.entries.count == 1)
        #expect(store.entries[0].requestHeaders["Authorization"] == "<redacted>")
        #expect(store.entries[0].requestHeaders["Accept"] == "application/json")
        let loggedURL = store.entries[0].url?.absoluteString ?? ""
        let queryItems = URLComponents(string: loggedURL)?.queryItems
        #expect(queryItems?.first(where: { $0.name == "access_token" })?.value == "<redacted>")
        #expect(queryItems?.first(where: { $0.name == "sort" })?.value == "recent")
    }
}
#endif
