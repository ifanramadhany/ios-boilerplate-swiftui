import SwiftUI

struct AppTabBar: View {
    let tabs: [AppTab]
    let selectedTab: AppTab
    let title: (AppTab) -> String
    let onSelect: (AppTab) -> Void

    var body: some View {
        HStack(spacing: AppSpacing.small) {
            ForEach(tabs) { tab in
                Button {
                    onSelect(tab)
                } label: {
                    AppTabBarItem(
                        title: title(tab),
                        systemImage: tab.systemImage,
                        isSelected: selectedTab == tab
                    )
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(AppSpacing.small)
        .background {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(AppColor.surface)
                .shadow(color: .black.opacity(0.12), radius: 18, x: 0, y: 8)
        }
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(AppColor.divider, lineWidth: 1)
        }
        .padding(.horizontal, AppSpacing.medium)
        .padding(.bottom, AppSpacing.small)
    }
}

private struct AppTabBarItem: View {
    let title: String
    let systemImage: String
    let isSelected: Bool

    var body: some View {
        VStack(spacing: AppSpacing.xSmall) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 32, height: 28)

            Text(title)
                .font(AppTypography.caption.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .foregroundStyle(isSelected ? AppColor.primary : AppColor.textTertiary)
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(AppColor.primary.opacity(0.12))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

#Preview {
    AppTabBar(
        tabs: AppTab.allCases,
        selectedTab: .home,
        title: { $0.title(for: .system) },
        onSelect: { _ in }
    )
}
