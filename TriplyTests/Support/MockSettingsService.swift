@testable import Triply

struct MockSettingsService: SettingsService {
    let result: Result<[SettingsItem], Error>

    func loadItems() async throws -> [SettingsItem] {
        try result.get()
    }
}
