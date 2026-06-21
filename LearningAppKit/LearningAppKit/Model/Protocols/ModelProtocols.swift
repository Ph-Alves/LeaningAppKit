//
//  ModelProtocols.swift
//  LearningAppKit
//
//  Created by Paulo Henrique Costa Alves on 21/06/26.
//

import Foundation
import SwiftData

// MARK: - Repository
// Responsável por definir as operações que um repository deve seguir.
// usa associatedType para que a implementação concreta defina qual a entidade do repository.
protocol RepositoryProtocol<Model> {
    associatedtype Model: PersistentModel
    
    func getAll() throws -> [Model]
    func add(item: Model) throws -> Void
    func delete(item: Model) throws -> Void
    func save() throws -> Void
}
