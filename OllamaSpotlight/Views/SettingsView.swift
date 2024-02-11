//
//  SettingsView.swift
//  OllamaSpotlight
//
//  Created by Oleg Rybalko on 10.02.2024.
//

import SwiftUI
import KeyboardShortcuts

struct SettingsView: View {
    @EnvironmentObject var ollamaModel: OllamaModel
    @EnvironmentObject var settings: Settings
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                KeyboardShortcuts.Recorder("Hotkey:", name: .openSearchWindow)
                    .font(.body)
                
                Picker("Model:", selection: $settings.selectedModel) {
                    ForEach(ollamaModel.availableModels, id: \.self) { name in
                        Text(name)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: settings.selectedModel) {
                    settings.update(model: settings.selectedModel)
                }
            }
            
            Divider()
            
            Button("History", systemImage: "book") {
                openWindow(id: "history")
            }
            .buttonStyle(.borderless)
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

#Preview {
    SettingsView()
        .frame(width: 300)
        .environment(OllamaModel())
        .environment(Settings())
}
