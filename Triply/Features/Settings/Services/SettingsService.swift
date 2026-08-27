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
                title: .appVersion,
                subtitleText: "1.0"
            ),
            SettingsItem(
                id: "environment",
                title: .environment,
                subtitle: environment.settingsText
            )
        ]
    }
}

private extension AppEnvironment {
    var settingsText: SettingsLocalizedText {
        switch self {
        case .development:
            .developmentEnvironment
        case .staging:
            .stagingEnvironment
        case .production:
            .productionEnvironment
        }
    }
}
