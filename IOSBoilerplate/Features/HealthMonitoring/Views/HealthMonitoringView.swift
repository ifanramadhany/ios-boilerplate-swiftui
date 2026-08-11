import SwiftUI

struct HealthMonitoringView: View {
    @StateObject private var viewModel: HealthMonitoringViewModel

    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.medium),
        GridItem(.flexible(), spacing: AppSpacing.medium)
    ]

    init(service: HealthMonitoringService) {
        _viewModel = StateObject(wrappedValue: HealthMonitoringViewModel(service: service))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                headerView

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(AppTypography.caption)
                        .foregroundStyle(.red)
                }

                if let summary = viewModel.summary {
                    LazyVGrid(columns: columns, spacing: AppSpacing.medium) {
                        HealthMetricCard(
                            kind: .steps,
                            value: summary.steps.formatted(),
                            unit: "health.unit.steps"
                        )

                        HealthMetricCard(
                            kind: .activeEnergy,
                            value: summary.activeEnergyKilocalories.formatted(.number.precision(.fractionLength(0))),
                            unit: "health.unit.kcal"
                        )

                        HealthMetricCard(
                            kind: .heartRate,
                            value: formattedHeartRate(from: summary),
                            unit: "health.unit.bpm"
                        )
                    }
                } else if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.large)
                }
            }
            .padding(AppSpacing.medium)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await viewModel.load()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(viewModel.isLoading)
                .accessibilityLabel(Text("health.action.refresh"))
            }
        }
        .task {
            await viewModel.load()
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            HealthMonitoringLocalizedText.title.text
                .font(AppTypography.title.weight(.bold))
                .foregroundStyle(AppColor.textPrimary)

            HealthMonitoringLocalizedText.subtitle.text
                .font(AppTypography.body)
                .foregroundStyle(AppColor.textSecondary)
        }
    }

    private func formattedHeartRate(from summary: HealthMonitoringSummary) -> String {
        guard let heartRate = summary.heartRateBeatsPerMinute else {
            return "--"
        }

        return heartRate.formatted(.number.precision(.fractionLength(0)))
    }
}

struct HealthMonitoringView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HealthMonitoringView(service: PreviewHealthMonitoringService())
                .navigationTitle(AppTab.healthMonitoring.title(for: .system))
        }
    }
}

private struct HealthMetricCard: View {
    let kind: HealthMetricKind
    let value: String
    let unit: LocalizedStringKey

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.medium) {
            Image(systemName: kind.systemImage)
                .font(.title2)
                .foregroundStyle(AppColor.iconPrimary)
                .frame(width: 32, height: 32)

            VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                kind.title.text
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textSecondary)
                    .lineLimit(2)

                HStack(alignment: .firstTextBaseline, spacing: AppSpacing.xSmall) {
                    Text(verbatim: value)
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(AppColor.textPrimary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.75)

                    Text(unit)
                        .font(AppTypography.caption)
                        .foregroundStyle(AppColor.textSecondary)
                        .lineLimit(1)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 132, alignment: .topLeading)
        .padding(AppSpacing.medium)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct PreviewHealthMonitoringService: HealthMonitoringService {
    func requestAuthorizationIfNeeded() async throws {}

    func loadTodaySummary() async throws -> HealthMonitoringSummary {
        HealthMonitoringSummary(
            steps: 7531,
            activeEnergyKilocalories: 416,
            heartRateBeatsPerMinute: 74,
            heartRateRecordedAt: Date(),
            measuredAt: Date()
        )
    }
}

private extension HealthMonitoringLocalizedText {
    var text: Text {
        switch self {
        case .title:
            Text("health.title")
        case .subtitle:
            Text("health.subtitle")
        case .steps:
            Text("health.metric.steps")
        case .activeEnergy:
            Text("health.metric.active_energy")
        case .heartRate:
            Text("health.metric.heart_rate")
        case .unavailable:
            Text("health.error.unavailable")
        case .loadError:
            Text("health.error.load")
        }
    }
}
