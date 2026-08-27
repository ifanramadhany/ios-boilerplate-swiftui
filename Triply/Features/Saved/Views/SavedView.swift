import SwiftUI

struct SavedView: View {
    var body: some View {
        TriplyPlaceholderView(
            systemImage: AppTab.saved.systemImage,
            title: "Saved places",
            message: "Your favorite destinations will appear here."
        )
    }
}

#Preview {
    SavedView()
}
