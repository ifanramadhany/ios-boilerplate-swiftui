import SwiftUI

struct FloatingTabBar: View {
    @Binding var selectedTab: AppTab

    let constants: Constants

    init(
        selectedTab: Binding<AppTab>,
        constants: Constants = Constants()
    ) {
        _selectedTab = selectedTab
        self.constants = constants
    }

    var body: some View {
        ZStack(alignment: .top) {
            tabBar
                .padding(.top, constants.barTopPadding)

            exploreButton
        }
        .padding(.horizontal, constants.horizontalPadding)
        .padding(.bottom, constants.bottomPadding)
    }

    private var tabBar: some View {
        HStack(spacing: constants.itemSpacing) {
            tabButtons(for: [.home, .saved])

            Color.clear
                .frame(width: constants.centerSlotWidth)
                .frame(height: constants.normalItemHeight)
                .accessibilityHidden(true)

            tabButtons(for: [.trips, .profile])
        }
        .frame(height: constants.tabBarHeight)
        .padding(.horizontal, constants.innerHorizontalPadding)
        .background(tabBarBackground)
    }

    private func tabButtons(for tabs: [AppTab]) -> some View {
        ForEach(tabs) { tab in
            Button {
                select(tab)
            } label: {
                FloatingTabItem(
                    tab: tab,
                    isSelected: selectedTab == tab,
                    constants: constants
                )
            }
            .buttonStyle(.plain)
            .frame(maxWidth: .infinity)
        }
    }

    private var exploreButton: some View {
        Button {
            select(.explore)
        } label: {
            ZStack {
                Circle()
                    .fill(triplyGradient)
                    .frame(
                        width: constants.centerButtonSize + constants.centerButtonRingWidth,
                        height: constants.centerButtonSize + constants.centerButtonRingWidth
                    )

                Circle()
                    .fill(triplyGradient)
                    .frame(width: constants.centerButtonSize, height: constants.centerButtonSize)

                Image(systemName: AppTab.explore.systemImage)
                    .font(.system(size: constants.centerIconSize, weight: .bold))
                    .foregroundStyle(.white)

                if selectedTab == .explore {
                    ExploreSelectionArc()
                        .stroke(
                            .white.opacity(0.9),
                            style: StrokeStyle(
                                lineWidth: constants.activeIndicatorHeight,
                                lineCap: .round
                            )
                        )
                        .frame(
                            width: constants.centerIndicatorWidth,
                            height: constants.centerIndicatorHeight
                        )
                        .offset(y: constants.centerIndicatorOffset)
                }
            }
            .frame(
                width: constants.centerButtonSize + constants.centerButtonRingWidth,
                height: constants.centerButtonSize + constants.centerButtonRingWidth
            )
            .scaleEffect(selectedTab == .explore ? constants.selectedCenterScale : 1)
            .shadow(color: AppColor.primaryDark.opacity(0.2), radius: 12, x: 0, y: 6)
            .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(FloatingCenterButtonStyle(pressedScale: constants.pressedCenterScale))
        .accessibilityLabel(AppTab.explore.accessibilityLabel)
        .accessibilityAddTraits(selectedTab == .explore ? [.isButton, .isSelected] : .isButton)
    }

    private var tabBarBackground: some View {
        FloatingTabBarShape(
            cornerRadius: constants.tabBarCornerRadius,
            notchRadius: constants.centerNotchRadius
        )
        .fill(triplyGradient, style: FillStyle(eoFill: true))
        .clipShape(RoundedRectangle(cornerRadius: constants.tabBarCornerRadius, style: .continuous))
        .shadow(color: AppColor.primaryDark.opacity(0.24), radius: 16, x: 0, y: 8)
    }

    private var triplyGradient: LinearGradient {
        LinearGradient(
            colors: [AppColor.accent, AppColor.primary],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private func select(_ tab: AppTab) {
        withAnimation(.easeInOut(duration: constants.animationDuration)) {
            selectedTab = tab
        }
    }
}

extension FloatingTabBar {
    struct Constants {
        let tabBarHeight: CGFloat = 78
        let tabBarCornerRadius: CGFloat = 44
        let centerButtonSize: CGFloat = 56
        let centerButtonRingWidth: CGFloat = 8
        let exploreButtonGap: CGFloat = -30
        let centerIconSize: CGFloat = 23
        let iconSize: CGFloat = 21
        let horizontalPadding: CGFloat = 6
        let innerHorizontalPadding: CGFloat = 18
        let bottomPadding: CGFloat = 8
        let itemSpacing: CGFloat = 4
        let centerSlotWidth: CGFloat = 90
        let centerNotchRadius: CGFloat = 40
        let normalItemHeight: CGFloat = 68
        let minimumHitSize: CGFloat = 44
        let activeIndicatorWidth: CGFloat = 18
        let activeIndicatorHeight: CGFloat = 3
        let centerIndicatorWidth: CGFloat = 24
        let centerIndicatorHeight: CGFloat = 8
        let centerIndicatorOffset: CGFloat = 25
        let selectedCenterScale: CGFloat = 1.04
        let pressedCenterScale: CGFloat = 0.94
        let animationDuration: TimeInterval = 0.2

        var barTopPadding: CGFloat {
            centerButtonSize + centerButtonRingWidth + exploreButtonGap
        }

        var contentBottomInset: CGFloat {
            tabBarHeight + barTopPadding + bottomPadding + 16
        }
    }
}

private struct ExploreSelectionArc: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.maxY)
        )
        return path
    }
}

private struct FloatingTabBarShape: Shape {
    let cornerRadius: CGFloat
    let notchRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(
            in: rect,
            cornerSize: CGSize(width: cornerRadius, height: cornerRadius),
            style: .continuous
        )

        let notchHorizontalRadius = notchRadius * 1.15
        let notchBlendRadius = notchRadius * 0.36
        let topY = rect.minY
        let centerX = rect.midX
        let leftStart = CGPoint(x: centerX - notchHorizontalRadius - notchBlendRadius, y: topY)
        let bottomCenter = CGPoint(x: centerX, y: topY + notchRadius)
        let rightEnd = CGPoint(x: centerX + notchHorizontalRadius + notchBlendRadius, y: topY)

        path.move(to: leftStart)
        path.addCurve(
            to: bottomCenter,
            control1: CGPoint(x: leftStart.x + notchBlendRadius * 1.35, y: topY),
            control2: CGPoint(x: centerX - notchHorizontalRadius * 0.82, y: topY + notchRadius)
        )
        path.addCurve(
            to: rightEnd,
            control1: CGPoint(x: centerX + notchHorizontalRadius * 0.82, y: topY + notchRadius),
            control2: CGPoint(x: rightEnd.x - notchBlendRadius * 1.35, y: topY)
        )
        path.closeSubpath()

        return path
    }
}

private struct FloatingTabItem: View {
    let tab: AppTab
    let isSelected: Bool
    let constants: FloatingTabBar.Constants

    var body: some View {
        VStack(spacing: AppSpacing.xSmall) {
            Image(systemName: tab.systemImage)
                .font(.system(size: constants.iconSize, weight: .semibold))
                .symbolRenderingMode(.monochrome)
                .foregroundStyle(.white)
                .frame(width: constants.minimumHitSize, height: constants.minimumHitSize)
                .scaleEffect(isSelected ? 1.08 : 1)

            Capsule()
                .fill(.white.opacity(isSelected ? 0.9 : 0))
                .frame(
                    width: isSelected ? constants.activeIndicatorWidth : constants.activeIndicatorHeight,
                    height: constants.activeIndicatorHeight
                )
        }
        .frame(maxWidth: .infinity)
        .frame(height: constants.normalItemHeight)
        .contentShape(Rectangle())
        .accessibilityLabel(tab.accessibilityLabel)
        .accessibilityAddTraits(isSelected ? [.isButton, .isSelected] : .isButton)
    }
}

private struct FloatingCenterButtonStyle: ButtonStyle {
    let pressedScale: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1)
            .animation(.easeInOut(duration: 0.2), value: configuration.isPressed)
    }
}

#Preview("Home Selected") {
    FloatingTabBarPreview(selectedTab: .home)
}

#Preview("Saved Selected") {
    FloatingTabBarPreview(selectedTab: .saved)
}

#Preview("Explore Selected") {
    FloatingTabBarPreview(selectedTab: .explore)
}

#Preview("Trips Selected") {
    FloatingTabBarPreview(selectedTab: .trips)
}

#Preview("Profile Selected") {
    FloatingTabBarPreview(selectedTab: .profile)
}

#Preview("Light Mode") {
    FloatingTabBarPreview(selectedTab: .home)
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    FloatingTabBarPreview(selectedTab: .explore)
        .preferredColorScheme(.dark)
}

private struct FloatingTabBarPreview: View {
    @State var selectedTab: AppTab

    var body: some View {
        ZStack(alignment: .bottom) {
            AppColor.background.ignoresSafeArea()

            FloatingTabBar(selectedTab: $selectedTab)
        }
    }
}
