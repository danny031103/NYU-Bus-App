//
//  NYU_BUS_ROUTERApp.swift
//  NYU_BUS_ROUTER
//
//  Created by Daniel Brito on 7/18/24.
//

import SwiftUI
import SwiftData

@main
struct NYU_BUS_ROUTERApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(sharedModelContainer)
    }
}
