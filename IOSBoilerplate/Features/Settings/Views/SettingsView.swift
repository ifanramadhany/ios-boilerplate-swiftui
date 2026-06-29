import SwiftUI

struct SettingsView: View {
    @AppStorage("appAppearance") private var appAppearance = AppAppearance.system.rawValue
    @StateObject private var viewModel: SettingsViewModel

    init(service: SettingsService = DefaultSettingsService()) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(service: service))
    }

    var body: some View {
        List {
            Section("Appearance") {
                Picker("Theme", selection: $appAppearance) {
                    ForEach(AppAppearance.allCases) { appearance in
                        Text(appearance.title)
                            .tag(appearance.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("About") {
                ForEach(viewModel.items) { item in
                    VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                        Text(item.title)
                            .font(AppTypography.body)

                        if let subtitle = item.subtitle {
                            Text(subtitle)
                                .font(AppTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, AppSpacing.xSmall)
                }
            }
        }
        .task {
            await viewModel.load()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            SettingsView()
                .navigationTitle("Settings")
        }
    }
}
