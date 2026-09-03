import SwiftUI

struct ProfileView: View {
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
                            title: "Settings",
                            subtitle: "Theme, language, and app information."
                        )
                    }
                    .buttonStyle(.plain)

                    Button {
                        activeSheet = .uiLearning
                    } label: {
                        ProfileActionRow(
                            systemImage: "rectangle.3.group",
                            title: "UI learning",
                            subtitle: "Compare SwiftUI and UIKit programmatic examples."
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
            switch sheet {
            case .settings:
                SettingsView(service: settingsService)
                    .presentationDragIndicator(.visible)
            case .uiLearning:
                UILearningView()
                    .presentationDragIndicator(.visible)
            }
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

            Text("Profile")
                .font(AppTypography.title.weight(.bold))
                .foregroundStyle(AppColor.textPrimary)

            Text("Manage your traveler details and preferences.")
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
    let title: String
    let subtitle: String

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
