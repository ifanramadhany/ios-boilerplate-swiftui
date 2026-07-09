import SwiftUI

enum AppLanguage: String, CaseIterable, Identifiable {
    case system
    case english
    case indonesian

    var id: String {
        rawValue
    }

    var titleKey: LocalizedStringKey {
        switch self {
        case .system:
            "language.system"
        case .english:
            "language.english"
        case .indonesian:
            "language.indonesian"
        }
    }

    var locale: Locale {
        switch self {
        case .system:
            .autoupdatingCurrent
        case .english:
            Locale(identifier: "en")
        case .indonesian:
            Locale(identifier: "id")
        }
    }

    func localizedString(forKey key: String) -> String {
        bundle.localizedString(forKey: key, value: nil, table: nil)
    }

    private var bundle: Bundle {
        switch self {
        case .system:
            .main
        case .english:
            Bundle.localizedBundle(for: "en")
        case .indonesian:
            Bundle.localizedBundle(for: "id")
        }
    }
}

private extension Bundle {
    static func localizedBundle(for languageCode: String) -> Bundle {
        guard
            let path = main.path(forResource: languageCode, ofType: "lproj"),
            let bundle = Bundle(path: path)
        else {
            return .main
        }

        return bundle
    }
}
