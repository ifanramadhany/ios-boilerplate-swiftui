import SwiftUI

enum AppTab: Hashable {
    case home
    case healthMonitoring
    case settings

    var titleKey: String {
        switch self {
        case .home:
            "tab.home"
        case .healthMonitoring:
            "tab.health"
        case .settings:
            "tab.settings"
        }
    }

    func title(for language: AppLanguage) -> String {
        language.localizedString(forKey: titleKey)
    }

    var systemImage: String {
        switch self {
        case .home:
            "house"
        case .healthMonitoring:
            "heart.text.square"
        case .settings:
            "gearshape"
        }
    }
}

enum AppRoute: Hashable {
    case home
    case healthMonitoring
    case settings
}
