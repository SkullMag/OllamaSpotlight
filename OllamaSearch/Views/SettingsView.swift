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
            HStack {
                Form {
                    KeyboardShortcuts.Recorder("Hotkey:", name: .openSearchWindow)
                        .font(.body)
                }
                Spacer()
            }
        }
        .padding()
    }
}

#Preview {
    SettingsView()
        .frame(width: 300)
}
