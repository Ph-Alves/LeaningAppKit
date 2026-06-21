//
//  SecondItem.swift
//  LearningAppKit
//
//  Created by Paulo Henrique Costa Alves on 21/06/26.
//

import Foundation
import SwiftData

// MARK: - SwiftData Model
// Define uma tabela do swift data chamada SecondItem
// Possui uma linha da tabela, chamada name.
@Model
final class SecondItem {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
