import Combine
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var content = HomeContent(
        title: "Hello, world!",
        subtitle: "IOSBoilerplate is ready."
    )

    private let service: HomeService

    init() {
        service = DefaultHomeService()
    }

    init(service: HomeService) {
        self.service = service
    }

    func load() async {
        do {
            content = try await service.loadContent()
        } catch {
            content = HomeContent(
                title: "Something went wrong",
                subtitle: error.localizedDescription
            )
        }
    }
}
