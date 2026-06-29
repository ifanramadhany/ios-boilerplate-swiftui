import Foundation

protocol SettingsService {
    func loadItems() async throws -> [SettingsItem]
}

struct DefaultSettingsService: SettingsService {
    private let environment: AppEnvironment

    init(environment: AppEnvironment = .current) {
        self.environment = environment
    }

    func loadItems() async throws -> [SettingsItem] {
        [
            SettingsItem(
                id: "app-version",
                title: "App Version",
                subtitle: "1.0"
            ),
            SettingsItem(
                id: "environment",
                title: "Environment",
                subtitle: environment.rawValue.capitalized
            )
        ]
    }
}
