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
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"

        return [
            SettingsItem(
                id: "app-version",
                title: .appVersion,
                subtitleText: appVersion
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
