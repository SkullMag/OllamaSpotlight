//
//  OllamaSearchModel.swift
//  OllamaSpotlight
//
//  Created by Oleg Rybalko on 05.02.2024.
//

import Combine
import OllamaKit
import SwiftUI

class OllamaModel: ObservableObject, Observable {
    @Published var response: String = ""
    @Published var isGenerating: Bool?
    @Published var availableModels: Array<String> = []
    
    private var ollamaKit = OllamaKit(baseURL: URL(string: "http://localhost:11434")!)
    private var generation: AnyCancellable?
    private var models: AnyCancellable?
    private var history: History?
    
    init() {
        fetchModels()
    }
    
    @MainActor
    func generate(model: String, prompt: String) async {
        // Check if server is on
        if !(await ollamaKit.reachable()) {
            return
        }
        
        // Clear previous data
        response = ""
        self.isGenerating = true
        
        // Start generation
        generation = ollamaKit.generate(data: OKGenerateRequestData(model: model, prompt: prompt))
            .sink { [weak self] completion in
                // TODO: handle errors
                switch (completion) {
                default:
                    self?.isGenerating = false
                    
                    // Save the response in history
                    if let history = self?.history, let response = self?.response {
                        history.save(model: model, prompt: prompt, response: response)
                    }
                }
            } receiveValue: { [weak self ] resp in
                self?.response += resp.response
            }
    }

    func clear() {
        response = ""
        isGenerating = nil
    }
    
    func fetchModels() {
        models = ollamaKit.models().sink { completion in
            // TODO: handle errors
        } receiveValue: { [weak self] resp in
            self?.availableModels = resp.models.map { $0.name }
        }
    }
    
    func inject(_ history: History) {
        self.history = history
    }
}

