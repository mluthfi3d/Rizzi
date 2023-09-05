//
//  RizziApp.swift
//  Rizzi
//
//  Created by Muhammad Luthfi on 05/09/23.
//

import SwiftUI

@main
struct RizziApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
