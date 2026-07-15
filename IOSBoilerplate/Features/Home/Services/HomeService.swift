protocol HomeService {
    func loadContent() async throws -> HomeContent
}

struct DefaultHomeService: HomeService {
    private let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func loadContent() async throws -> HomeContent {
        HomeContent(
            title: .welcomeTitle,
            subtitle: .welcomeSubtitle
        )
    }
}
