import Combine
import SwiftUI

@MainActor
final class HealthMonitoringViewModel: ObservableObject {
    @Published private(set) var summary: HealthMonitoringSummary?
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?

    private let service: HealthMonitoringService

    init(service: HealthMonitoringService) {
        self.service = service
    }

    func load() async {
        guard !isLoading else {
            return
        }

        isLoading = true
        defer {
            isLoading = false
        }

        do {
            try await service.requestAuthorizationIfNeeded()
            summary = try await service.loadTodaySummary()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
