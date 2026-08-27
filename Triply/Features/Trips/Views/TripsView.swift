import SwiftUI

struct TripsView: View {
    var body: some View {
        TriplyPlaceholderView(
            systemImage: AppTab.trips.systemImage,
            title: "My trips",
            message: "Your upcoming and past travel plans will appear here."
        )
    }
}

#Preview {
    TripsView()
}
