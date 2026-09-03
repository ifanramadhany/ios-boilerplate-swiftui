import SwiftUI

struct TriplyPlaceholderView: View {
    let systemImage: String
    let title: LocalizedStringKey
    let message: LocalizedStringKey

    var body: some View {
        ScrollView {
            VStack(spacing: AppSpacing.medium) {
                Image(systemName: systemImage)
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundStyle(AppColor.primary)
                    .frame(width: 72, height: 72)
                    .background(AppColor.primary.opacity(0.12))
                    .clipShape(Circle())

                VStack(spacing: AppSpacing.small) {
                    Text(title)
                        .font(AppTypography.title.weight(.bold))
                        .foregroundStyle(AppColor.textPrimary)

                    Text(message)
                        .font(AppTypography.body)
                        .foregroundStyle(AppColor.textSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, AppSpacing.large)
            .padding(.top, AppSpacing.xLarge)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
    }
}

#Preview {
    TriplyPlaceholderView(
        systemImage: "magnifyingglass",
        title: "explore.title",
        message: "explore.subtitle"
    )
}
