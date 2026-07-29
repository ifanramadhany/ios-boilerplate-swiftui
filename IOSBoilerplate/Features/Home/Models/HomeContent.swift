import Foundation

struct HomeContent: Equatable {
    let title: HomeLocalizedText
    let subtitle: HomeLocalizedText?
    let subtitleText: String?
    let pokemon: [PokemonCard]
    let hasMorePages: Bool

    init(
        title: HomeLocalizedText,
        subtitle: HomeLocalizedText? = nil,
        subtitleText: String? = nil,
        pokemon: [PokemonCard] = [],
        hasMorePages: Bool = true
    ) {
        self.title = title
        self.subtitle = subtitle
        self.subtitleText = subtitleText
        self.pokemon = pokemon
        self.hasMorePages = hasMorePages
    }
}

enum HomeLocalizedText: Equatable {
    case welcomeTitle
    case welcomeSubtitle
    case pokemonTitle
    case pokemonSubtitle
    case loadError

    var key: String {
        switch self {
        case .welcomeTitle:
            "home.welcome.title"
        case .welcomeSubtitle:
            "home.welcome.subtitle"
        case .pokemonTitle:
            "home.pokemon.title"
        case .pokemonSubtitle:
            "home.pokemon.subtitle"
        case .loadError:
            "home.error.load"
        }
    }
}

struct PokemonCard: Equatable, Identifiable {
    let id: Int
    let name: String
    let imageURL: URL?

    var displayName: String {
        name
            .split(separator: "-")
            .map(\.capitalized)
            .joined(separator: " ")
    }

    var formattedNumber: String {
        "#\(String(format: "%03d", id))"
    }
}
