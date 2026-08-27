import Foundation
import Testing
@testable import Triply

@MainActor
struct HealthMonitoringViewModelTests {
    @Test func loadsSummaryFromInjectedService() async {
        let summary = HealthMonitoringSummary(
            steps: 7531,
            activeEnergyKilocalories: 416,
            heartRateBeatsPerMinute: 74,
            heartRateRecordedAt: Date(timeIntervalSince1970: 1000),
            measuredAt: Date(timeIntervalSince1970: 2000)
        )
        let service = MockHealthMonitoringService(summaryResult: .success(summary))
        let viewModel = HealthMonitoringViewModel(service: service)

        await viewModel.load()

        #expect(service.didRequestAuthorization)
        #expect(viewModel.summary == summary)
        #expect(viewModel.errorMessage == nil)
    }

    @Test func showsErrorWhenServiceFails() async {
        let service = MockHealthMonitoringService(
            authorizationResult: .failure(MockError.failure),
            summaryResult: .success(.mock)
        )
        let viewModel = HealthMonitoringViewModel(service: service)

        await viewModel.load()

        #expect(service.didRequestAuthorization)
        #expect(viewModel.summary == nil)
        #expect(viewModel.errorMessage != nil)
    }
}
