struct SettingsItem: Identifiable, Equatable {
    let id: String
    let title: SettingsLocalizedText
    let subtitle: SettingsLocalizedText?
    let subtitleText: String?

    init(
        id: String,
        title: SettingsLocalizedText,
        subtitle: SettingsLocalizedText? = nil,
        subtitleText: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.subtitleText = subtitleText
    }
}

enum SettingsLocalizedText: Equatable {
    case appVersion
    case environment
    case loadError
    case theme
    case systemAppearance
    case developmentEnvironment
    case stagingEnvironment
    case productionEnvironment

    var key: String {
        switch self {
        case .appVersion:
            "settings.about.app_version"
        case .environment:
            "settings.about.environment"
        case .loadError:
            "settings.error.load"
        case .theme:
            "settings.theme.title"
        case .systemAppearance:
            "appearance.system"
        case .developmentEnvironment:
            "environment.development"
        case .stagingEnvironment:
            "environment.staging"
        case .productionEnvironment:
            "environment.production"
        }
    }
}
