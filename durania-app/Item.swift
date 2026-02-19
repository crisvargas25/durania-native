//
//  Item.swift
//  durania-app
//
//  Created by Cristian Vargas on 19/02/26.
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
