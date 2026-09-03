import SwiftUI

struct SavedView: View {
    var body: some View {
        TriplyPlaceholderView(
            systemImage: AppTab.saved.systemImage,
            title: "saved.title",
            message: "saved.subtitle"
        )
    }
}

#Preview {
    SavedView()
}
