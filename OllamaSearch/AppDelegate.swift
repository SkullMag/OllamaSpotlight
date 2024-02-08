//
//  AppDelegate.swift
//  OllamaSearch
//
//  Created by Oleg Rybalko on 07.02.2024.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    var entryPanel: FloatingPanel!
    var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        // I've opted to ignore top safe area as well, since we're hiding the traffic icons
        let contentView = ContentView()
            .frame(minWidth: 200)
            .ignoresSafeArea(.all)
    
        // It is needed to activate window on menu button click
        NSApplication.shared.setActivationPolicy(.accessory)
        
        // Create the window and set the content view.
        entryPanel = FloatingPanel(contentRect: NSRect(x: 0, y: 0, width: 512, height: 0), backing: .buffered, defer: false)

        entryPanel.contentView = NSHostingView(rootView: contentView)

        // Center doesn't place it in the absolute center, see the documentation for more details
        entryPanel.center()

        // Shows the panel and makes it active
        entryPanel.makeKeyAndOrderFront(nil)
        
        // Create status bar button
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        // Check if status button is available
        if let btn = statusItem?.button {
            btn.image = NSImage(systemSymbolName: "hammer", accessibilityDescription: nil)
            btn.action = #selector(menuButtonToggle)
        }
        
        NSApplication.shared.activate()
    }
    
    @objc
    private func menuButtonToggle() {
        NSApplication.shared.activate()
        entryPanel.makeKeyAndOrderFront(nil)
    }
}
