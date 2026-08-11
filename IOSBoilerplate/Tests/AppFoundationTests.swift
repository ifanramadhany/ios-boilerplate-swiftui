import Foundation
import Testing
@testable import IOSBoilerplate

struct AppFoundationTests {
    @Test func trimmedRemovesWhitespaceAndNewlines() {
        #expect("  Hello\n".trimmed == "Hello")
    }

    @Test func appAppearanceMapsToColorScheme() {
        #expect(AppAppearance.system.colorScheme == nil)
        #expect(AppAppearance.light.colorScheme != nil)
        #expect(AppAppearance.dark.colorScheme != nil)
    }

    @Test func appLanguageMapsToLocale() {
        #expect(AppLanguage.english.locale.identifier == "en")
        #expect(AppLanguage.indonesian.locale.identifier == "id")
    }

    @Test func appEnvironmentReadsKnownValueFromInfoDictionary() {
        let environment = AppEnvironment.current(from: ["APP_ENVIRONMENT": "production"])

        #expect(environment == .production)
    }

    @Test func appEnvironmentFallsBackToDevelopmentForUnknownValue() {
        let environment = AppEnvironment.current(from: ["APP_ENVIRONMENT": "unknown"])

        #expect(environment == .development)
    }

    @Test func appEnvironmentReadsBaseURLFromInfoDictionary() {
        let baseURL = AppEnvironment.baseURL(from: ["API_BASE_URL": "https://api.example.test"])

        #expect(baseURL.absoluteString == "https://api.example.test")
    }

    @Test func appEnvironmentFallsBackToDefaultBaseURL() {
        let baseURL = AppEnvironment.baseURL(from: ["API_BASE_URL": ""])

        #expect(baseURL == AppEnvironment.defaultBaseURL)
    }
}
