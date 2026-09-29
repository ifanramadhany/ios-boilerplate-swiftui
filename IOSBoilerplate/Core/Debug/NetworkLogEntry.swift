#if DEBUG
import Foundation

struct NetworkLogEntry: Equatable, Identifiable {
    let id: UUID
    let requestedAt: Date
    let method: String
    let url: URL?
    let statusCode: Int?
    let durationMilliseconds: Int
    let requestHeaders: [String: String]
    let errorMessage: String?

    init(
        id: UUID = UUID(),
        requestedAt: Date,
        method: String,
        url: URL?,
        statusCode: Int?,
        durationMilliseconds: Int,
        requestHeaders: [String: String],
        errorMessage: String?
    ) {
        self.id = id
        self.requestedAt = requestedAt
        self.method = method
        self.url = url
        self.statusCode = statusCode
        self.durationMilliseconds = durationMilliseconds
        self.requestHeaders = requestHeaders
        self.errorMessage = errorMessage
    }
}

#endif
