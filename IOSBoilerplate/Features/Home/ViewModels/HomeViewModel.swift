import Combine
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published private(set) var content = HomeContent(
        title: .welcomeTitle,
        subtitle: .welcomeSubtitle
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
                title: .loadError,
                subtitleText: error.localizedDescription
            )
        }
    }
}
