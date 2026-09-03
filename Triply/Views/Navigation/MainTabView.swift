import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: AppTab = .home
    @State private var homePath = NavigationPath()
    @State private var savedPath = NavigationPath()
    @State private var explorePath = NavigationPath()
    @State private var tripsPath = NavigationPath()
    @State private var profilePath = NavigationPath()

    let dependencies: DependencyContainer
    private let tabBarConstants = FloatingTabBar.Constants()

    init(dependencies: DependencyContainer = DependencyContainer()) {
        self.dependencies = dependencies
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            selectedTabContent

            FloatingTabBar(
                selectedTab: $selectedTab,
                constants: tabBarConstants
            )
        }
        .background(AppColor.background.ignoresSafeArea())
        .tint(AppColor.primary)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    @ViewBuilder
    private var selectedTabContent: some View {
        switch selectedTab {
        case .home:
            NavigationStack(path: $homePath) {
                HomeView(service: dependencies.homeService)
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
                    .appNavigationHeader(title: AppTab.home.title)
            }
        case .saved:
            NavigationStack(path: $savedPath) {
                SavedView()
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
                    .appNavigationHeader(title: AppTab.saved.title)
            }
        case .explore:
            NavigationStack(path: $explorePath) {
                ExploreView()
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
                    .appNavigationHeader(title: AppTab.explore.title)
            }
        case .trips:
            NavigationStack(path: $tripsPath) {
                TripsView()
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
                    .appNavigationHeader(title: AppTab.trips.title)
            }
        case .profile:
            NavigationStack(path: $profilePath) {
                ProfileView(settingsService: dependencies.settingsService)
                    .navigationDestination(for: AppRoute.self) { route in
                        destination(for: route)
                    }
                    .appNavigationHeader(title: AppTab.profile.title)
            }
        }
    }

    @ViewBuilder
    private func destination(for route: AppRoute) -> some View {
        switch route {
        case .home:
            HomeView(service: dependencies.homeService)
        case .saved:
            SavedView()
        case .explore:
            ExploreView()
        case .trips:
            TripsView()
        case .profile:
            ProfileView(settingsService: dependencies.settingsService)
        }
    }
}

#Preview("Main Tabs Light") {
    MainTabView()
}

#Preview("Main Tabs Dark") {
    MainTabView()
        .preferredColorScheme(.dark)
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
                Color.clear.frame(height: FloatingTabBar.Constants().contentBottomInset)
            }
    }
}
