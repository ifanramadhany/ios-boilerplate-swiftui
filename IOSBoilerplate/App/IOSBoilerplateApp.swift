//
//  IOSBoilerplateApp.swift
//  IOSBoilerplate
//
//  Created by Ifan Ramadhany on 19/06/2026.
//

import SwiftUI

@main
struct IOSBoilerplateApp: App {
    private let dependencies = DependencyContainer()

    var body: some Scene {
        WindowGroup {
            AppRootView(dependencies: dependencies)
        }
    }
}
