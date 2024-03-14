//
//  HydrifyApp.swift
//  Hydrify
//
//  Created by Shubham Tambade on 14/03/24.
//

import SwiftUI

@main
struct HydrifyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
