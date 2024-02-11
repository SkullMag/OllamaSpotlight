//
//  Settings.swift
//  OllamaSpotlight
//
//  Created by Oleg Rybalko on 11.02.2024.
//

import SwiftUI

class Settings: ObservableObject, Observable {
    @Published var selectedModel: String = "llama2:latest"
    
    init () {
        if let model = UserDefaults.standard.value(forKey: "ollamaSpotlightModel") as? String {
            selectedModel = model
        }
    }
}
