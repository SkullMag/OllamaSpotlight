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
        WindowGroup("Settings") {
            SettingsView()
                .frame(minWidth: 300)
                .environment(appDelegate.ollamaModel)
                .environment(appDelegate.settings)
        }
        .windowResizability(.contentSize)
    }
}
