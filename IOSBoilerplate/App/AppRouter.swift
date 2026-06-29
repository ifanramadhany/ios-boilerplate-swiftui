import Combine
import SwiftUI

@MainActor
final class AppRouter: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var homePath = NavigationPath()
    @Published var settingsPath = NavigationPath()

    func select(_ tab: AppTab) {
        selectedTab = tab
    }

    func resetSelectedTab() {
        switch selectedTab {
        case .home:
            homePath = NavigationPath()
        case .settings:
            settingsPath = NavigationPath()
        }
    }
}
