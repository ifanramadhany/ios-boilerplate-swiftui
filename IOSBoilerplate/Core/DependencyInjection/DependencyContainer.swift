final class DependencyContainer {
    let environment: AppEnvironment
    let apiClient: APIClient
    let homeService: HomeService
    let settingsService: SettingsService

    init(
        environment: AppEnvironment = .current,
        apiClient: APIClient? = nil,
        homeService: HomeService? = nil,
        settingsService: SettingsService? = nil
    ) {
        self.environment = environment
        self.apiClient = apiClient ?? URLSessionAPIClient(baseURL: environment.baseURL)
        self.homeService = homeService ?? DefaultHomeService()
        self.settingsService = settingsService ?? DefaultSettingsService(environment: environment)
    }
}
