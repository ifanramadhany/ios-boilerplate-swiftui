import SwiftUI

struct MainTabView: View {
    @AppStorage("appLanguage") private var appLanguage = AppLanguage.system.rawValue
    @EnvironmentObject private var router: AppRouter

    let dependencies: DependencyContainer

    init(dependencies: DependencyContainer = DependencyContainer()) {
        self.dependencies = dependencies
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            selectedTabContent

            AppTabBar(
                tabs: AppTab.allCases,
                selectedTab: router.selectedTab,
                title: { $0.title(for: selectedLanguage) },
                onSelect: selectTab
            )
        }
        .background(AppColor.background.ignoresSafeArea())
        .tint(AppColor.primary)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    private var selectedLanguage: AppLanguage {
        AppLanguage(rawValue: appLanguage) ?? .system
    }

    @ViewBuilder
    private var selectedTabContent: some View {
        switch router.selectedTab {
        case .home:
            NavigationStack(path: $router.homePath) {
                ContentView(service: dependencies.homeService)
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
                    .appNavigationHeader(title: AppTab.home.title(for: selectedLanguage))
            }
        case .healthMonitoring:
            NavigationStack(path: $router.healthMonitoringPath) {
                HealthMonitoringView(service: dependencies.healthMonitoringService)
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
                    .appNavigationHeader(title: AppTab.healthMonitoring.title(for: selectedLanguage))
            }
        case .settings:
            NavigationStack(path: $router.settingsPath) {
                SettingsView(service: dependencies.settingsService)
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
                    .appNavigationHeader(title: AppTab.settings.title(for: selectedLanguage))
            }
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .home:
            ContentView(service: dependencies.homeService)
        case .healthMonitoring:
            HealthMonitoringView(service: dependencies.healthMonitoringService)
        case .settings:
            SettingsView(service: dependencies.settingsService)
        }
    }

    private func selectTab(_ tab: AppTab) {
        if router.selectedTab == tab {
            router.resetSelectedTab()
        } else {
            router.select(tab)
        }
    }
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AppRouter())
    }
}

private extension View {
    func appNavigationHeader(title: String) -> some View {
        navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaInset(edge: .top, spacing: 0) {
                AppNavigationHeader(title: title)
            }
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Color.clear.frame(height: 88)
            }
    }
}
