import Foundation
@testable import IOSBoilerplate

final class MockHealthMonitoringService: HealthMonitoringService {
    let authorizationResult: Result<Void, Error>
    let summaryResult: Result<HealthMonitoringSummary, Error>
    private(set) var didRequestAuthorization = false

    init(
        authorizationResult: Result<Void, Error> = .success(()),
        summaryResult: Result<HealthMonitoringSummary, Error>
    ) {
        self.authorizationResult = authorizationResult
        self.summaryResult = summaryResult
    }

    func requestAuthorizationIfNeeded() async throws {
        didRequestAuthorization = true
        try authorizationResult.get()
    }

    func loadTodaySummary() async throws -> HealthMonitoringSummary {
        try summaryResult.get()
    }
}

extension HealthMonitoringSummary {
    static let mock = HealthMonitoringSummary(
        steps: 1000,
        activeEnergyKilocalories: 100,
        heartRateBeatsPerMinute: 70,
        heartRateRecordedAt: Date(timeIntervalSince1970: 1000),
        measuredAt: Date(timeIntervalSince1970: 2000)
    )
}
