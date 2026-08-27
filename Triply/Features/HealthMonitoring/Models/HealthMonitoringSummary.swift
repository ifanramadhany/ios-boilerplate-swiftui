import Foundation

struct HealthMonitoringSummary: Equatable {
    let steps: Int
    let activeEnergyKilocalories: Double
    let heartRateBeatsPerMinute: Double?
    let heartRateRecordedAt: Date?
    let measuredAt: Date
}

enum HealthMetricKind: CaseIterable, Equatable, Identifiable {
    case steps
    case activeEnergy
    case heartRate

    var id: Self {
        self
    }

    var title: HealthMonitoringLocalizedText {
        switch self {
        case .steps:
            .steps
        case .activeEnergy:
            .activeEnergy
        case .heartRate:
            .heartRate
        }
    }

    var systemImage: String {
        switch self {
        case .steps:
            "figure.walk"
        case .activeEnergy:
            "flame"
        case .heartRate:
            "heart"
        }
    }
}

enum HealthMonitoringLocalizedText: Equatable {
    case title
    case subtitle
    case steps
    case activeEnergy
    case heartRate
    case unavailable
    case loadError

    var key: String {
        switch self {
        case .title:
            "health.title"
        case .subtitle:
            "health.subtitle"
        case .steps:
            "health.metric.steps"
        case .activeEnergy:
            "health.metric.active_energy"
        case .heartRate:
            "health.metric.heart_rate"
        case .unavailable:
            "health.error.unavailable"
        case .loadError:
            "health.error.load"
        }
    }
}
