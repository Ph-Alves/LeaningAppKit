//
//  LearningAppKitApp.swift
//  LearningAppKit
//
//  Created by Paulo Henrique Costa Alves on 21/06/26.
//

import SwiftUI
import SwiftData

@main
struct LearningAppKitApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self, SecondItem.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: HomeViewModel(
                itemRepository: GenericRepository<Item>(modelContext: sharedModelContainer.mainContext),
                secondItemRepository: GenericRepository<SecondItem>(modelContext: sharedModelContainer.mainContext)
            ))
        }
        .modelContainer(sharedModelContainer)
    }
}
