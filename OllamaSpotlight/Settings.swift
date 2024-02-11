//
//  Settings.swift
//  OllamaSpotlight
//
//  Created by Oleg Rybalko on 11.02.2024.
//

import SwiftUI

class Settings: ObservableObject, Observable {
    @Published var selectedModel: String = "llama2:latest"
    private let userDefaultsKey = "ollamaSpotlightModel"
    
    init () {
        if let model = UserDefaults.standard.value(forKey: userDefaultsKey) as? String {
            selectedModel = model
        }
    }

    func update(model: String) {
        selectedModel = model
        UserDefaults.standard.set(model, forKey: userDefaultsKey)
    }
}
