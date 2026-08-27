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

    var title: String {
        switch self {
        case .home:
            "Home"
        case .saved:
            "Saved"
        case .explore:
            "Explore"
        case .trips:
            "Trips"
        case .profile:
            "Profile"
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

    var accessibilityLabel: String {
        switch self {
        case .home:
            "Home"
        case .saved:
            "Saved places"
        case .explore:
            "Explore destinations"
        case .trips:
            "My trips"
        case .profile:
            "Profile"
        }
    }

    var isCenterAction: Bool {
        self == .explore
    }

    static let normalTabs: [AppTab] = [.home, .saved, .trips, .profile]
}
