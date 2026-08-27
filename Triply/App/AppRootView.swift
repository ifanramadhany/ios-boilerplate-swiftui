import SwiftUI

struct AppRootView: View {
    @AppStorage("appAppearance") private var appAppearance = AppAppearance.system.rawValue
    @AppStorage("appLanguage") private var appLanguage = AppLanguage.system.rawValue
    @StateObject private var router = AppRouter()
    #if DEBUG
    @State private var isNetworkLogPresented = false
    #endif

    private let dependencies: DependencyContainer

    init(dependencies: DependencyContainer = DependencyContainer()) {
        self.dependencies = dependencies
    }

    var body: some View {
        MainTabView(dependencies: dependencies)
            .environmentObject(router)
            .environment(\.locale, AppLanguage(rawValue: appLanguage)?.locale ?? .autoupdatingCurrent)
            .preferredColorScheme(AppAppearance(rawValue: appAppearance)?.colorScheme)
        #if DEBUG
            .background {
                DebugKeyboardShortcutView(
                    input: "z",
                    modifierFlags: [.command, .control],
                    discoverabilityTitle: "Network Log"
                ) {
                    isNetworkLogPresented = true
                }
            }
            .sheet(isPresented: $isNetworkLogPresented) {
                NetworkLogView(store: .shared) {
                    isNetworkLogPresented = false
                }
            }
        #endif
    }
}

struct AppRootView_Previews: PreviewProvider {
    static var previews: some View {
        AppRootView()
    }
}
