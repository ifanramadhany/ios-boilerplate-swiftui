import Foundation

struct AppConfiguration: Equatable {
    let environment: AppEnvironment
    let baseURL: URL

    static var current: AppConfiguration {
        current(from: Bundle.main.infoDictionary)
    }

    static func current(from infoDictionary: [String: Any]?) -> AppConfiguration {
        AppConfiguration(
            environment: AppEnvironment.current(from: infoDictionary),
            baseURL: AppEnvironment.baseURL(from: infoDictionary)
        )
    }
}
