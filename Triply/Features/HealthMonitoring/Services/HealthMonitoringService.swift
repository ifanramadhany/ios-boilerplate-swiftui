import Foundation
import HealthKit

protocol HealthMonitoringService {
    func requestAuthorizationIfNeeded() async throws
    func loadTodaySummary() async throws -> HealthMonitoringSummary
}

enum HealthMonitoringError: Error, Equatable {
    case healthDataUnavailable
    case authorizationDenied
    case missingQuantityType(String)
}

extension HealthMonitoringError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .healthDataUnavailable:
            NSLocalizedString(HealthMonitoringLocalizedText.unavailable.key, comment: "")
        case .authorizationDenied:
            NSLocalizedString(HealthMonitoringLocalizedText.loadError.key, comment: "")
        case let .missingQuantityType(identifier):
            "Health data type is unavailable: \(identifier)"
        }
    }
}

struct DefaultHealthMonitoringService: HealthMonitoringService {
    private let healthStore: HKHealthStore
    private let calendar: Calendar
    private let now: () -> Date

    init(
        healthStore: HKHealthStore = HKHealthStore(),
        calendar: Calendar = .current,
        now: @escaping () -> Date = Date.init
    ) {
        self.healthStore = healthStore
        self.calendar = calendar
        self.now = now
    }

    func requestAuthorizationIfNeeded() async throws {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw HealthMonitoringError.healthDataUnavailable
        }

        let readTypes = try Set<HKObjectType>([
            quantityType(for: .stepCount),
            quantityType(for: .activeEnergyBurned),
            quantityType(for: .heartRate)
        ])

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            healthStore.requestAuthorization(toShare: Set<HKSampleType>(), read: readTypes) { success, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                guard success else {
                    continuation.resume(throwing: HealthMonitoringError.authorizationDenied)
                    return
                }

                continuation.resume()
            }
        }
    }

    func loadTodaySummary() async throws -> HealthMonitoringSummary {
        let endDate = now()
        let startDate = calendar.startOfDay(for: endDate)

        let steps = try await cumulativeQuantity(
            identifier: .stepCount,
            unit: .count(),
            startDate: startDate,
            endDate: endDate
        )
        let activeEnergy = try await cumulativeQuantity(
            identifier: .activeEnergyBurned,
            unit: .kilocalorie(),
            startDate: startDate,
            endDate: endDate
        )
        let heartRate = try await latestHeartRate(startDate: startDate, endDate: endDate)

        return HealthMonitoringSummary(
            steps: Int(steps.rounded()),
            activeEnergyKilocalories: activeEnergy,
            heartRateBeatsPerMinute: heartRate?.value,
            heartRateRecordedAt: heartRate?.recordedAt,
            measuredAt: endDate
        )
    }

    private func cumulativeQuantity(
        identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        startDate: Date,
        endDate: Date
    ) async throws -> Double {
        let quantityType = try quantityType(for: identifier)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKStatisticsQuery(
                quantityType: quantityType,
                quantitySamplePredicate: predicate,
                options: .cumulativeSum
            ) { _, statistics, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                let value = statistics?.sumQuantity()?.doubleValue(for: unit) ?? 0
                continuation.resume(returning: value)
            }

            healthStore.execute(query)
        }
    }

    private func latestHeartRate(
        startDate: Date,
        endDate: Date
    ) async throws -> HeartRateSample? {
        let quantityType = try quantityType(for: .heartRate)
        let predicate = HKQuery.predicateForSamples(
            withStart: startDate,
            end: endDate,
            options: .strictStartDate
        )
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

        return try await withCheckedThrowingContinuation { continuation in
            let query = HKSampleQuery(
                sampleType: quantityType,
                predicate: predicate,
                limit: 1,
                sortDescriptors: [sortDescriptor]
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }

                guard let sample = samples?.first as? HKQuantitySample else {
                    continuation.resume(returning: nil)
                    return
                }

                let unit = HKUnit.count().unitDivided(by: .minute())
                continuation.resume(returning: HeartRateSample(
                    value: sample.quantity.doubleValue(for: unit),
                    recordedAt: sample.endDate
                ))
            }

            healthStore.execute(query)
        }
    }

    private func quantityType(for identifier: HKQuantityTypeIdentifier) throws -> HKQuantityType {
        guard let quantityType = HKObjectType.quantityType(forIdentifier: identifier) else {
            throw HealthMonitoringError.missingQuantityType(identifier.rawValue)
        }

        return quantityType
    }
}

private struct HeartRateSample: Equatable {
    let value: Double
    let recordedAt: Date
}
