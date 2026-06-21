//
//  Item.swift
//  LearningAppKit
//
//  Created by Paulo Henrique Costa Alves on 21/06/26.
//

import Foundation
import SwiftData

// MARK: - SwiftData Model
// Define uma tabela do swift data chamada Item
// Possui uma linha da tabela, chamada timestamp.
@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
