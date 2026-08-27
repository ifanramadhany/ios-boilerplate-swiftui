//
//  ContentView.swift
//  Triply
//
//  Created by Ifan Ramadhany on 19/06/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: HomeViewModel
    private let columns = [
        GridItem(.flexible(), spacing: AppSpacing.medium),
        GridItem(.flexible(), spacing: AppSpacing.medium)
    ]

    init(service: HomeService) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(service: service))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppSpacing.large) {
                headerView

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(AppTypography.caption)
                        .foregroundStyle(.red)
                }

                LazyVGrid(columns: columns, spacing: AppSpacing.medium) {
                    ForEach(viewModel.content.pokemon) { pokemon in
                        PokemonCardView(pokemon: pokemon)
                            .task {
                                await loadMoreIfNeeded(currentItem: pokemon)
                            }
                    }
                }

                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppSpacing.medium)
                }
            }
            .padding(AppSpacing.medium)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(AppColor.background)
        .task {
            await viewModel.load()
        }
    }

    private var headerView: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            viewModel.content.title.text
                .font(AppTypography.title.weight(.bold))
                .foregroundStyle(AppColor.textPrimary)

            if let subtitle = viewModel.content.subtitle {
                subtitle.text
                    .font(AppTypography.body)
                    .foregroundStyle(AppColor.textSecondary)
            } else if let subtitleText = viewModel.content.subtitleText {
                Text(subtitleText)
                    .font(AppTypography.body)
                    .foregroundStyle(AppColor.textSecondary)
            }
        }
    }

    private func loadMoreIfNeeded(currentItem: PokemonCard) async {
        guard currentItem == viewModel.content.pokemon.last else {
            return
        }

        await viewModel.loadNextPage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(service: PreviewHomeService())
    }
}

private struct PreviewHomeService: HomeService {
    func loadContent() async throws -> HomeContent {
        HomeContent(
            title: .pokemonTitle,
            subtitle: .pokemonSubtitle,
            pokemon: PokemonCard.previewItems,
            hasMorePages: false
        )
    }

    func loadPokemon(offset: Int, limit: Int) async throws -> PokemonPage {
        PokemonPage(items: PokemonCard.previewItems, hasMorePages: false)
    }
}

private extension HomeLocalizedText {
    var text: Text {
        switch self {
        case .welcomeTitle:
            Text("home.welcome.title")
        case .welcomeSubtitle:
            Text("home.welcome.subtitle")
        case .pokemonTitle:
            Text("home.pokemon.title")
        case .pokemonSubtitle:
            Text("home.pokemon.subtitle")
        case .loadError:
            Text("home.error.load")
        }
    }
}

private struct PokemonCardView: View {
    let pokemon: PokemonCard

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.small) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(AppColor.background)

                AsyncImage(url: pokemon.imageURL) { phase in
                    switch phase {
                    case let .success(image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "photo")
                            .font(.title2)
                            .foregroundStyle(AppColor.iconPrimary)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
                .padding(AppSpacing.medium)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)

            VStack(alignment: .leading, spacing: AppSpacing.xSmall) {
                Text(verbatim: pokemon.formattedNumber)
                    .font(AppTypography.caption)
                    .foregroundStyle(AppColor.textSecondary)

                Text(verbatim: pokemon.displayName)
                    .font(.headline)
                    .foregroundStyle(AppColor.textPrimary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.85)
            }
        }
        .padding(AppSpacing.small)
        .background(AppColor.surface)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private extension PokemonCard {
    static let previewItems = [
        PokemonCard(
            id: 1,
            name: "bulbasaur",
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        ),
        PokemonCard(
            id: 4,
            name: "charmander",
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/4.png")
        ),
        PokemonCard(
            id: 7,
            name: "squirtle",
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/7.png")
        ),
        PokemonCard(
            id: 25,
            name: "pikachu",
            imageURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/25.png")
        )
    ]
}
