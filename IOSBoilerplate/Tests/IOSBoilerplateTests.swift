//
//  IOSBoilerplateTests.swift
//  IOSBoilerplateTests
//
//  Created by Ifan Ramadhany on 19/06/2026.
//

import Foundation
import Testing
@testable import IOSBoilerplate

struct IOSBoilerplateTests {
    @Test func trimmedRemovesWhitespaceAndNewlines() {
        #expect("  Hello\n".trimmed == "Hello")
    }

    @Test func appAppearanceMapsToColorScheme() {
        #expect(AppAppearance.system.colorScheme == nil)
        #expect(AppAppearance.light.colorScheme != nil)
        #expect(AppAppearance.dark.colorScheme != nil)
    }

    @MainActor
    @Test func homeViewModelLoadsContentFromInjectedService() async {
        let content = HomeContent(title: "Injected", subtitle: "Loaded from a mock service")
        let viewModel = HomeViewModel(service: MockHomeService(result: .success(content)))

        await viewModel.load()

        #expect(viewModel.content == content)
    }

    @MainActor
    @Test func homeViewModelShowsErrorContentWhenServiceFails() async {
        let viewModel = HomeViewModel(service: MockHomeService(result: .failure(MockError.failure)))

        await viewModel.load()

        #expect(viewModel.content.title == "Something went wrong")
        #expect(viewModel.content.subtitle == MockError.failure.localizedDescription)
    }

    @MainActor
    @Test func settingsViewModelLoadsItemsFromInjectedService() async {
        let items = [
            SettingsItem(id: "theme", title: "Theme", subtitle: "System")
        ]
        let viewModel = SettingsViewModel(service: MockSettingsService(result: .success(items)))

        await viewModel.load()

        #expect(viewModel.items == items)
    }
}

private struct MockHomeService: HomeService {
    let result: Result<HomeContent, Error>

    func loadContent() async throws -> HomeContent {
        try result.get()
    }
}

private struct MockSettingsService: SettingsService {
    let result: Result<[SettingsItem], Error>

    func loadItems() async throws -> [SettingsItem] {
        try result.get()
    }
}

private enum MockError: Error {
    case failure
}
