//
//  OllamaSearchModel.swift
//  OllamaSearch
//
//  Created by Oleg Rybalko on 05.02.2024.
//

import Combine
import OllamaKit
import SwiftUI

class OllamaSearchModel: ObservableObject {
    @Published var response: String = ""
    @Published var isGenerating: Bool?
    
    private var ollamaKit = OllamaKit(baseURL: URL(string: "http://localhost:11434")!)
    private var generation: AnyCancellable?
    
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
                switch (completion) {
                default:
                    self?.isGenerating = false
                }
            } receiveValue: { [weak self ] resp in
                self?.response += resp.response
            }
    }
}

