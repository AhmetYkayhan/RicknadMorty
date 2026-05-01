//
//  RicknadMortyApp.swift
//  RicknadMorty
//
//  Created by Yasin Kayhan on 27.04.2026.
//

import SwiftUI
import FirebaseCore

@main
struct RicknadMortyApp: App {

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView(
                coordinator: AppCoordinator(
                    container: AppDependencyContainer()
                )
            )
        }
    }
}
