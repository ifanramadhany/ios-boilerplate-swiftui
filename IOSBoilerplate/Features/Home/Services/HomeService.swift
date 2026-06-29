protocol HomeService {
    func loadContent() async throws -> HomeContent
}

struct DefaultHomeService: HomeService {
    func loadContent() async throws -> HomeContent {
        HomeContent(
            title: "Hello, world!",
            subtitle: "IOSBoilerplate is ready."
        )
    }
}
