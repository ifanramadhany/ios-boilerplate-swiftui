import SwiftUI

struct ExploreView: View {
    var body: some View {
        TriplyPlaceholderView(
            systemImage: AppTab.explore.systemImage,
            title: "explore.title",
            message: "explore.subtitle"
        )
    }
}

#Preview {
    ExploreView()
}
