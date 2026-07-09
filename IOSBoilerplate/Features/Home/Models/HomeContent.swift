struct HomeContent: Equatable {
    let title: HomeLocalizedText
    let subtitle: HomeLocalizedText?
    let subtitleText: String?

    init(
        title: HomeLocalizedText,
        subtitle: HomeLocalizedText? = nil,
        subtitleText: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.subtitleText = subtitleText
    }
}

enum HomeLocalizedText: Equatable {
    case welcomeTitle
    case welcomeSubtitle
    case loadError

    var key: String {
        switch self {
        case .welcomeTitle:
            "home.welcome.title"
        case .welcomeSubtitle:
            "home.welcome.subtitle"
        case .loadError:
            "home.error.load"
        }
    }
}
