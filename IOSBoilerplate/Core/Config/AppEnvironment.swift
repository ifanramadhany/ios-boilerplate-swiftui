import Foundation

enum AppEnvironment: String {
    case development
    case staging
    case production

    static let defaultBaseURL = URL(string: "https://api.example.com") ?? URL(fileURLWithPath: "/")

    static var current: AppEnvironment {
        current(from: Bundle.main.infoDictionary)
    }

    static var currentBaseURL: URL {
        baseURL(from: Bundle.main.infoDictionary)
    }

    static func current(from infoDictionary: [String: Any]?) -> AppEnvironment {
        guard
            let value = infoDictionary?["APP_ENVIRONMENT"] as? String,
            let environment = AppEnvironment(rawValue: value)
        else {
            return .development
        }

        return environment
    }

    static func baseURL(from infoDictionary: [String: Any]?) -> URL {
        guard
            let value = infoDictionary?["API_BASE_URL"] as? String,
            let url = URL(string: value)
        else {
            return defaultBaseURL
        }

        return url
    }
}
