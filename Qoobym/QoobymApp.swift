//
//  QoobymApp.swift
//  Qoobym
//
//  Created by Anatoliy Petrov on 3. 5. 2025..
//

import SwiftUI

@main
struct QoobymApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
