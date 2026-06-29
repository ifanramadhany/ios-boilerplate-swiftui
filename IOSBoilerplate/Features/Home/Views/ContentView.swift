//
//  ContentView.swift
//  IOSBoilerplate
//
//  Created by Ifan Ramadhany on 19/06/2026.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel: HomeViewModel

    init(service: HomeService = DefaultHomeService()) {
        _viewModel = StateObject(wrappedValue: HomeViewModel(service: service))
    }

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(AppColor.iconPrimary)

            Text(viewModel.content.title)
                .font(AppTypography.title)
                .foregroundStyle(AppColor.textPrimary)

            Text(viewModel.content.subtitle)
                .font(AppTypography.body)
                .foregroundStyle(AppColor.textSecondary)
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
        ContentView()
    }
}
