import SwiftUI

struct AppRootView: View {
    @AppStorage("appAppearance") private var appAppearance = AppAppearance.system.rawValue
    @StateObject private var router = AppRouter()

    private let dependencies: DependencyContainer

    init(dependencies: DependencyContainer = DependencyContainer()) {
        self.dependencies = dependencies
    }

    var body: some View {
        MainTabView(dependencies: dependencies)
            .environmentObject(router)
            .preferredColorScheme(AppAppearance(rawValue: appAppearance)?.colorScheme)
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
    }
}
