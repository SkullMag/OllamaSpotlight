//
//  AppDelegate.swift
//  OllamaSpotlight
//
//  Created by Oleg Rybalko on 07.02.2024.
//

import AppKit
import KeyboardShortcuts
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    var entryPanel: FloatingPanel!
    var statusItem: NSStatusItem?
    var history = History()
    var ollamaModel = OllamaModel()
    var settings = Settings()
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        // I've opted to ignore top safe area as well, since we're hiding the traffic icons
        ollamaModel.inject(history)
        let contentView = SpotlightView()
            .frame(minWidth: 200)
            .ignoresSafeArea(.all)
            .environment(ollamaModel)
            .environment(settings)
    
        // It is needed to activate window on menu button click
        NSApp.setActivationPolicy(.accessory)
        
        // Create the window and set the content view.
        entryPanel = FloatingPanel(contentRect: NSRect(x: 0, y: 0, width: 700, height: 0), backing: .buffered, defer: false)

        entryPanel.contentView = NSHostingView(rootView: contentView)

        // Center doesn't place it in the absolute center, see the documentation for more details
        entryPanel.center()

        // Shows the panel and makes it active
        entryPanel.makeKeyAndOrderFront(nil)
        
        // Create status bar button
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // Check if status button is available
        if let btn = statusItem?.button {
            btn.image = NSImage(systemSymbolName: "magnifyingglass", accessibilityDescription: nil)
            btn.action = #selector(menuButtonToggle)
        }
        
        NSApp.activate()
        
        KeyboardShortcuts.onKeyUp(for: .openSearchWindow) {
            NSApp.activate()
        }
    }
    
    @objc
    private func menuButtonToggle() {
        NSApp.activate()
        entryPanel.makeKeyAndOrderFront(nil)
    }
}
