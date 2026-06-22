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
    // Criamos nosso container
    // No swiftData, usamos 3 camadas, um Schema, que define as entidades
    // um Configuration que define como o banco é configurado
    // um Container, que agrupa tudo e monta nosso banco.
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
            // Aqui que definimos nossos tipos concretos.
            // É uma boa prática nossos tipos concretos estarem todos em um local só (Composition Root).
            // https://www.essentialdeveloper.com/articles/ios-composition-root-a-key-concept-for-achieving-loose-coupling-ios-lead-essentials-podcast-015/
            ContentView(viewModel: HomeViewModel(
                itemRepository: GenericRepository<Item>(modelContext: sharedModelContainer.mainContext),
                secondItemRepository: GenericRepository<SecondItem>(modelContext: sharedModelContainer.mainContext),
                testeRepository: GenericRepository<Teste>(modelContext: sharedModelContainer.mainContext)
            ))
        }
        .modelContainer(sharedModelContainer)
    }
}
