//
//  FloatingPanel.swift
//  MenuBarApp
//
//  Created by Oleg Rybalko on 07.02.2024.
//

import AppKit

class FloatingPanel: NSPanel {
    init(contentRect: NSRect, backing: NSWindow.BackingStoreType, defer flag: Bool) {
        // Not sure if .titled does affect anything here. Kept it because I think it might help with accessibility but I did not test that.
        super.init(contentRect: contentRect, styleMask: [.nonactivatingPanel, .titled, .resizable, .closable, .fullSizeContentView], backing: backing, defer: flag)

        // Set this if you want the panel to remember its size/position
//        self.setFrameAutosaveName("ollama search")

        // Allow the pannel to be on top of almost all other windows
        isFloatingPanel = true
        level = .floating

        // Allow the pannel to appear in a fullscreen space
        collectionBehavior.insert(.fullScreenAuxiliary)

        // While we may set a title for the window, don't show it
        titleVisibility = .hidden
        titlebarAppearsTransparent = true

        // Since there is no titlebar make the window moveable by click-dragging on the background
        isMovableByWindowBackground = true

        // Keep the panel around after closing since I expect the user to open/close it often
        isReleasedWhenClosed = false

        // Activate this if you want the window to hide once it is no longer focused
        hidesOnDeactivate = true

        // Hide the traffic icons (standard close, minimize, maximize buttons)
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
    }

    // `canBecomeKey` and `canBecomeMain` are required so that text inputs inside the panel can receive focus
    override var canBecomeKey: Bool {
        return true
    }

    override var canBecomeMain: Bool {
        return true
    }
}
