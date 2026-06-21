//
//  Item.swift
//  LearningAppKit
//
//  Created by Paulo Henrique Costa Alves on 21/06/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
