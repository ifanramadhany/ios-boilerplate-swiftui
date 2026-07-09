import SwiftUI

enum AppTab: Hashable {
    case home
    case settings

    var titleKey: String {
        switch self {
        case .home:
            "tab.home"
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
        case .settings:
            "gearshape"
        }
    }
}

enum AppRoute: Hashable {
    case home
    case settings
}
