import SwiftUI

struct TripsView: View {
    var body: some View {
        TriplyPlaceholderView(
            systemImage: AppTab.trips.systemImage,
            title: "trips.title",
            message: "trips.subtitle"
        )
    }
}

#Preview {
    TripsView()
}
