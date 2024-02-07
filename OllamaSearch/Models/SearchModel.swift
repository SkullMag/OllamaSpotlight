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
        if !(await ollamaKit.reachable()) {
            return
        }
        response = ""
        self.isGenerating = true
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

