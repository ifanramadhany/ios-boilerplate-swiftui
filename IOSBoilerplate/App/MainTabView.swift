import SwiftUI

struct MainTabView: View {
    @EnvironmentObject private var router: AppRouter

    let dependencies: DependencyContainer

    init(dependencies: DependencyContainer = DependencyContainer()) {
        self.dependencies = dependencies
    }

    var body: some View {
        TabView(selection: $router.selectedTab) {
            NavigationStack(path: $router.homePath) {
                ContentView(service: dependencies.homeService)
                    .navigationTitle(AppTab.home.title)
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
            }
            .tabItem {
                Label(AppTab.home.title, systemImage: AppTab.home.systemImage)
            }
            .tag(AppTab.home)

            NavigationStack(path: $router.settingsPath) {
                SettingsView(service: dependencies.settingsService)
                    .navigationTitle(AppTab.settings.title)
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
            }
            .tabItem {
                Label(AppTab.settings.title, systemImage: AppTab.settings.systemImage)
            }
            .tag(AppTab.settings)
        }
        .tint(AppColor.iconPrimary)
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .home:
            ContentView(service: dependencies.homeService)
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
