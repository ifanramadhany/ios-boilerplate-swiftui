//
//  ContentView.swift
//  IOSBoilerplate
//
//  Created by Ifan Ramadhany on 19/06/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: HomeViewModel

    init(service: HomeService) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(service: service))
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(AppColor.iconPrimary)

            viewModel.content.title.text
                .font(AppTypography.title)
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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .background(AppColor.background)
        .task {
            await viewModel.load()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(service: PreviewHomeService())
    }
}

private struct PreviewHomeService: HomeService {
    func loadContent() async throws -> HomeContent {
        HomeContent(title: .welcomeTitle, subtitle: .welcomeSubtitle)
    }
}

private extension HomeLocalizedText {
    var text: Text {
        switch self {
        case .welcomeTitle:
            Text("home.welcome.title")
        case .welcomeSubtitle:
            Text("home.welcome.subtitle")
        case .loadError:
            Text("home.error.load")
        }
    }
}
