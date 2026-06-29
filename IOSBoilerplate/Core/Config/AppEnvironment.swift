import Foundation

enum AppEnvironment: String {
    case development
    case staging
    case production

    static var current: AppEnvironment {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: "APP_ENVIRONMENT") as? String,
            let environment = AppEnvironment(rawValue: value)
        else {
            return .development
        }

        return environment
    }

    var baseURL: URL {
        let fallbackURL = URL(string: "https://api.example.com")

        guard
            let value = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
            let url = URL(string: value)
        else {
            return fallbackURL ?? URL(fileURLWithPath: "/")
        }

        return url
    }
}
