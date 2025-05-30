//
//  PhotoSelectorApp.swift
//  PhotoSelector
//
//  Created by 樋川大聖 on 2025/05/30.
//

import SwiftUI
import SwiftData

@main
struct PhotoSelectorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedPhoto.self)
    }
}
