import SwiftUI

struct ExploreView: View {
    var body: some View {
        TriplyPlaceholderView(
            systemImage: AppTab.explore.systemImage,
            title: "Explore destinations",
            message: "Search and discover new places for your next trip."
        )
    }
}

#Preview {
    ExploreView()
}
