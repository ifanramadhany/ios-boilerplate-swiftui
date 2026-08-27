import SwiftUI

struct ProfileView: View {
    var body: some View {
        TriplyPlaceholderView(
            systemImage: AppTab.profile.systemImage,
            title: "Profile",
            message: "Manage your traveler details and preferences."
        )
    }
}

#Preview {
    ProfileView()
}
