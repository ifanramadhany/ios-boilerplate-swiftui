import Foundation

final class DependencyContainer {
    let environment: AppEnvironment
    let baseURL: URL
    let apiClient: APIClient
    let homeService: HomeService
    let healthMonitoringService: HealthMonitoringService
    let settingsService: SettingsService

    init(
        environment: AppEnvironment = .current,
        baseURL: URL = AppEnvironment.currentBaseURL,
        apiClient: APIClient? = nil,
        homeService: HomeService? = nil,
        healthMonitoringService: HealthMonitoringService? = nil,
        settingsService: SettingsService? = nil
    ) {
        self.environment = environment
        self.baseURL = baseURL
        self.apiClient = apiClient ?? AlamofireAPIClient(baseURL: baseURL)
        self.homeService = homeService ?? DefaultHomeService(apiClient: self.apiClient)
        self.healthMonitoringService = healthMonitoringService ?? DefaultHealthMonitoringService()
        self.settingsService = settingsService ?? DefaultSettingsService(environment: environment)
    }
}
