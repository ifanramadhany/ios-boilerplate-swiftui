import Testing
@testable import Triply

@MainActor
struct SettingsViewModelTests {
    @Test func loadsItemsFromInjectedService() async {
        let items = [
            SettingsItem(id: "theme", title: .theme, subtitle: .systemAppearance)
        ]
        let viewModel = SettingsViewModel(service: MockSettingsService(result: .success(items)))

        await viewModel.load()

        #expect(viewModel.items == items)
    }
}
