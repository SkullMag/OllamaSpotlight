//
//  String+Extensions.swift
//  OllamaSpotlight
//
//  Created by Oleg Rybalko on 11.02.2024.
//

import AppKit

extension String {
    func copyToPasteboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(self, forType: .string)
    }
}
