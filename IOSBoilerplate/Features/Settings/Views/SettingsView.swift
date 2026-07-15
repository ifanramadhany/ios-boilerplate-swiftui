import SwiftUI

struct SettingsView: View {
    @AppStorage("appAppearance") private var appAppearance = AppAppearance.system.rawValue
    @AppStorage("appLanguage") private var appLanguage = AppLanguage.system.rawValue
    @StateObject private var viewModel: SettingsViewModel

    init(service: SettingsService) {
        _viewModel = StateObject(wrappedValue: SettingsViewModel(service: service))
    }

    var body: some View {
        List {
            Section("settings.section.appearance") {
                Picker("settings.theme.title", selection: $appAppearance) {
                    ForEach(AppAppearance.allCases) { appearance in
                        Text(appearance.titleKey)
                            .tag(appearance.rawValue)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("settings.section.language") {
                Picker("settings.language.title", selection: $appLanguage) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(language.titleKey)
                            .tag(language.rawValue)
                    }
                }
            }

            Section("settings.section.about") {
                ForEach(viewModel.items) { item in
                    VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                        item.title.text
                            .font(AppTypography.body)

                        if let subtitle = item.subtitle {
                            subtitle.text
                                .font(AppTypography.caption)
                                .foregroundStyle(.secondary)
                        } else if let subtitleText = item.subtitleText {
                            Text(subtitleText)
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
            SettingsView(service: PreviewSettingsService())
                .navigationTitle(AppTab.settings.title(for: .system))
        }
    }
}

private struct PreviewSettingsService: SettingsService {
    func loadItems() async throws -> [SettingsItem] {
        [
            SettingsItem(id: "app-version", title: .appVersion, subtitleText: "1.0"),
            SettingsItem(id: "environment", title: .environment, subtitle: .developmentEnvironment)
        ]
    }
}

private extension SettingsLocalizedText {
    var text: Text {
        switch self {
        case .appVersion:
            Text("settings.about.app_version")
        case .environment:
            Text("settings.about.environment")
        case .loadError:
            Text("settings.error.load")
        case .theme:
            Text("settings.theme.title")
        case .systemAppearance:
            Text("appearance.system")
        case .developmentEnvironment:
            Text("environment.development")
        case .stagingEnvironment:
            Text("environment.staging")
        case .productionEnvironment:
            Text("environment.production")
        }
    }
}
