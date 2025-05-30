//
//  PhotoDataModel.swift
//  PhotoSelector
//
//  Created by 樋川大聖 on 2025/05/30.
//

import SwiftData
import Foundation

@Model
class SavedPhoto {
    var identifier: String
    var addedDate: Date
    var order: Int

    init(identifier: String, addedDate: Date = Date(), order: Int = 0) {
        self.identifier = identifier
        self.addedDate = addedDate
        self.order = order
    }
} 