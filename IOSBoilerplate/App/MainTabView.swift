import SwiftUI

struct MainTabView: View {
    @AppStorage("appLanguage") private var appLanguage = AppLanguage.system.rawValue
    @EnvironmentObject private var router: AppRouter

    let dependencies: DependencyContainer

    init(dependencies: DependencyContainer = DependencyContainer()) {
        self.dependencies = dependencies
    }

    var body: some View {
        TabView(selection: $router.selectedTab) {
            NavigationStack(path: $router.homePath) {
                ContentView(service: dependencies.homeService)
                    .navigationTitle(AppTab.home.title(for: selectedLanguage))
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
            }
            .tabItem {
                Label {
                    Text(AppTab.home.title(for: selectedLanguage))
                } icon: {
                    Image(systemName: AppTab.home.systemImage)
                }
            }
            .tag(AppTab.home)

            NavigationStack(path: $router.healthMonitoringPath) {
                HealthMonitoringView(service: dependencies.healthMonitoringService)
                    .navigationTitle(AppTab.healthMonitoring.title(for: selectedLanguage))
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
            }
            .tabItem {
                Label {
                    Text(AppTab.healthMonitoring.title(for: selectedLanguage))
                } icon: {
                    Image(systemName: AppTab.healthMonitoring.systemImage)
                }
            }
            .tag(AppTab.healthMonitoring)

            NavigationStack(path: $router.settingsPath) {
                SettingsView(service: dependencies.settingsService)
                    .navigationTitle(AppTab.settings.title(for: selectedLanguage))
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
            }
            .tabItem {
                Label {
                    Text(AppTab.settings.title(for: selectedLanguage))
                } icon: {
                    Image(systemName: AppTab.settings.systemImage)
                }
            }
            .tag(AppTab.settings)
        }
        .tint(AppColor.iconPrimary)
    }

    private var selectedLanguage: AppLanguage {
        AppLanguage(rawValue: appLanguage) ?? .system
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
}

struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(AppRouter())
    }
}
