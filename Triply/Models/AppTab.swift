import SwiftUI

enum AppTab: Hashable, CaseIterable, Identifiable {
    case home
    case saved
    case explore
    case trips
    case profile

    var id: Self {
        self
    }

    var title: LocalizedStringKey {
        switch self {
        case .home:
            "tab.home"
        case .saved:
            "tab.saved"
        case .explore:
            "tab.explore"
        case .trips:
            "tab.trips"
        case .profile:
            "tab.profile"
        }
    }

    var systemImage: String {
        switch self {
        case .home:
            "house.fill"
        case .saved:
            "heart.fill"
        case .explore:
            "magnifyingglass"
        case .trips:
            "folder.fill"
        case .profile:
            "person.fill"
        }
    }

    var accessibilityLabel: LocalizedStringKey {
        switch self {
        case .home:
            "tab.home.accessibility"
        case .saved:
            "tab.saved.accessibility"
        case .explore:
            "tab.explore.accessibility"
        case .trips:
            "tab.trips.accessibility"
        case .profile:
            "tab.profile.accessibility"
        }
    }

    var isCenterAction: Bool {
        self == .explore
    }

    static let normalTabs: [AppTab] = [.home, .saved, .trips, .profile]
}
