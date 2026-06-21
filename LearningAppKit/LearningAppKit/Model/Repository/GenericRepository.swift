//
//  GenericRepository.swift
//  LearningAppKit
//
//  Created by Paulo Henrique Costa Alves on 21/06/26.
//

import Foundation
import SwiftData

// MARK: - GenericRepository
// Totalmente abstrato, permite qualquer entidade que seja persistida no swiftdata
// Se a entidade não está marcada com @Model, não é aceitada no repository por causa do PersistentModel
struct GenericRepository<Model: PersistentModel>: RepositoryProtocol {
    // MARK: - Variables
    private var context: ModelContext
    
    // MARK: - Init
    init(modelContext: ModelContext) {
        self.context = modelContext
    }
    
    // MARK: - CRUD Functions
    func getAll() throws -> [Model] {
        let descriptor = FetchDescriptor<Model>()
        return try context.fetch(descriptor)
    }
    
    func add(item: Model) throws {
        context.insert(item)
        try save()
    }
    
    func delete(item: Model) throws {
        context.delete(item)
        try save()
    }
    
    // Isso é para separar responsabilidade e permitir o edit
    // não fazemos o edit aqui, pois isso quebraria o genérico e o swiftData permite
    // um edit muito mais dinâmico, mudando a entidade via referência.
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
