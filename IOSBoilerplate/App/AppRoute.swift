import SwiftUI

enum AppTab: Hashable {
    case home
    case settings

    var title: String {
        switch self {
        case .home:
            "Home"
        case .settings:
            "Settings"
        }
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
