//
//  OllamaSpotlightApp.swift
//  OllamaSpotlight
//
//  Created by Oleg Rybalko on 05.02.2024.
//

import SwiftUI

@main
struct OllamaSpotlightApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    var body: some Scene {
        WindowGroup("Settings", id: "settings") {
            SettingsView()
                .frame(minWidth: 300)
                .environment(appDelegate.ollamaModel)
                .environment(appDelegate.settings)
        }
        .windowResizability(.contentMinSize)
        
        WindowGroup("History", id: "history") {
            HistoryView()
                .frame(minWidth: 300)
                .environment(appDelegate.history)
        }
        .windowResizability(.contentMinSize)
        .commandsRemoved()
    }
}
