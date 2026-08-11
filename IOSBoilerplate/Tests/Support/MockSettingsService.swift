@testable import IOSBoilerplate

struct MockSettingsService: SettingsService {
    let result: Result<[SettingsItem], Error>

    func loadItems() async throws -> [SettingsItem] {
        try result.get()
    }
}
