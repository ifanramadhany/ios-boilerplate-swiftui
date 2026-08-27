//
//  TriplyApp.swift
//  Triply
//
//  Created by Ifan Ramadhany on 19/06/2026.
//

import SwiftUI

@main
struct TriplyApp: App {
    private let dependencies = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            AppRootView(dependencies: dependencies)
        }
    }
}
