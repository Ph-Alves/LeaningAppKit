//
//  GenericRepository.swift
//  LearningAppKit
//
//  Created by Paulo Henrique Costa Alves on 21/06/26.
//

import Foundation
import SwiftData

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
    
    func save() throws {
        if context.hasChanges {
            try context.save()
        }
    }
}
