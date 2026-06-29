import Combine
import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published private(set) var items: [SettingsItem] = []

    private let service: SettingsService

    init() {
        service = DefaultSettingsService()
    }

    init(service: SettingsService) {
        self.service = service
    }

    func load() async {
        do {
            items = try await service.loadItems()
        } catch {
            items = [
                SettingsItem(
                    id: "error",
                    title: "Unable to load settings",
                    subtitle: error.localizedDescription
                )
            ]
        }
    }
}
