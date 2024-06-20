//
//  BankTrackerApp.swift
//  BankTracker
//
//  Created by Altay Kırlı on 20.06.2024.
//

import SwiftUI
import UserNotifications


@main
struct BankTrackerApp: App {
    let persistenceController = PersistenceController.shared
    init() {
        // Bildirim izinlerini isteme
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Bildirim izni verildi.")
            } else if let error = error {
                print("Bildirim izni reddedildi: \(error.localizedDescription)")
            }
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
