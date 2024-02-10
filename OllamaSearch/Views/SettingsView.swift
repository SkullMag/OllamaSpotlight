//
//  SettingsView.swift
//  OllamaSearch
//
//  Created by Oleg Rybalko on 10.02.2024.
//

import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Shortcuts:")
                .font(.title2)
            
            Form {
                KeyboardShortcuts.Recorder("Open search window: ", name: .openSearchWindow)
            }
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
