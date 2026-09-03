import SwiftUI

struct PrimaryButton: View {
    let title: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(.borderedProminent)
    }
}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(title: "common.continue") {}
            .padding()
    }
}
