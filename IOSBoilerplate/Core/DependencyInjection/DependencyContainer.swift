import Foundation

final class DependencyContainer {
    let configuration: AppConfiguration
    let apiClient: APIClient
    let homeService: HomeService
    let healthMonitoringService: HealthMonitoringService
    let settingsService: SettingsService

    init(
        configuration: AppConfiguration = .current,
        apiClient: APIClient? = nil,
        homeService: HomeService? = nil,
        healthMonitoringService: HealthMonitoringService? = nil,
        settingsService: SettingsService? = nil
    ) {
        self.configuration = configuration
        self.apiClient = apiClient ?? AlamofireAPIClient(baseURL: configuration.baseURL)
        self.homeService = homeService ?? DefaultHomeService(apiClient: self.apiClient)
        self.healthMonitoringService = healthMonitoringService ?? DefaultHealthMonitoringService()
        self.settingsService = settingsService ?? DefaultSettingsService(environment: configuration.environment)
    }
}
