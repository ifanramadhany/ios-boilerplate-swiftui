import SwiftUI

struct AppNavigationHeader: View {
    let title: String

    var body: some View {
        HStack(spacing: AppSpacing.medium) {
            VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                Text(title)
                    .font(AppTypography.title.weight(.bold))
                    .foregroundStyle(AppColor.textPrimary)

                Capsule()
                    .fill(AppColor.primary)
                    .frame(width: 36, height: 4)
            }

            Spacer(minLength: AppSpacing.medium)
        }
        .padding(.horizontal, AppSpacing.large)
        .padding(.top, AppSpacing.small)
        .padding(.bottom, AppSpacing.medium)
        .background(AppColor.surface)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(AppColor.divider)
                .frame(height: 1)
        }
    }
}

#Preview {
    AppNavigationHeader(title: "Home")
}
