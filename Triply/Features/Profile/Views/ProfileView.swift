import SwiftUI

struct ProfileView: View {
    @AppStorage("appAppearance") private var appAppearance = AppAppearance.system.rawValue
    @State private var activeSheet: ProfileSheet?

    private let settingsService: SettingsService

    init(settingsService: SettingsService = DefaultSettingsService()) {
        self.settingsService = settingsService
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                ProfileHeaderView()

                VStack(spacing: AppSpacing.medium) {
                    Button {
                        activeSheet = .settings
                    } label: {
                        ProfileActionRow(
                            systemImage: "gearshape.fill",
                            title: "profile.action.settings.title",
                            subtitle: "profile.action.settings.subtitle"
                        )
                    }
                    .buttonStyle(.plain)

                    Button {
                        activeSheet = .uiLearning
                    } label: {
                        ProfileActionRow(
                            systemImage: "rectangle.3.group",
                            title: "profile.action.ui_learning.title",
                            subtitle: "profile.action.ui_learning.subtitle"
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(AppSpacing.medium)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
        .sheet(item: $activeSheet) { sheet in
            sheetContent(for: sheet)
                .preferredColorScheme(selectedAppearance.colorScheme)
                .presentationDragIndicator(.visible)
        }
    }

    private var selectedAppearance: AppAppearance {
        AppAppearance(rawValue: appAppearance) ?? .system
    }

    @ViewBuilder
    private func sheetContent(for sheet: ProfileSheet) -> some View {
        switch sheet {
        case .settings:
            SettingsView(service: settingsService)
        case .uiLearning:
            UILearningView()
        }
    }
}

#Preview {
    ProfileView()
}

private struct ProfileHeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            Image(systemName: AppTab.profile.systemImage)
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(AppColor.primary)
                .frame(width: 72, height: 72)
                .background(AppColor.primary.opacity(0.12))
                .clipShape(Circle())

            Text("profile.title")
                .font(AppTypography.title.weight(.bold))
                .foregroundStyle(AppColor.textPrimary)

            Text("profile.subtitle")
                .font(AppTypography.body)
                .foregroundStyle(AppColor.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, AppSpacing.xLarge)
    }
}

private enum ProfileSheet: Identifiable {
    case settings
    case uiLearning

    var id: Self {
        self
    }
}

private struct ProfileActionRow: View {
    let systemImage: String
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey

    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            Image(systemName: systemImage)
                .font(.system(size: 22, weight: .semibold))
                .foregroundStyle(AppColor.primary)
                .frame(width: 44, height: 44)
                .background(AppColor.primary.opacity(0.12))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                Text(title)
                    .font(AppTypography.body.weight(.semibold))
                    .foregroundStyle(AppColor.textPrimary)

                Text(subtitle)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textSecondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(AppColor.textTertiary)
        }
        .padding(AppSpacing.medium)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
