//
//  ContentView.swift
//  OllamaSpotlight
//
//  Created by Oleg Rybalko on 05.02.2024.
//

import SwiftUI
import AppKit


struct SpotlightView: View {
    @EnvironmentObject var ollamaModel: OllamaModel
    @EnvironmentObject var settings: Settings
    @State private var prompt: String = ""
    @State private var selectedModel: String = ""
    
    @ViewBuilder
    var body: some View {
        VStack(alignment: .leading) {
            if ollamaModel.isGenerating == nil {
                Spacer()
                
                SearchFieldView
                
                Spacer()
            } else {
                SearchFieldView
                    .padding(.top)
                
                TextEditorView
                    .fixedSize(horizontal: false, vertical: true)
                    .padding([.top, .bottom])
                
                Spacer()
                
                if !ollamaModel.isGenerating! {
                    ButtonsView
                        .padding([.top, .bottom])
                }
            }
        }
        .padding([.leading, .trailing])
    }
    
    // MARK: - SearchFieldView
    private var SearchFieldView: some View {
        HStack(alignment: .center) {
            Image(systemName: "magnifyingglass")
                .font(.title)
            
            TextField("Ollama Search", text: $prompt)
                .textFieldStyle(.plain)
                .font(.title)
                .onSubmit {
                    Task {
                        await ollamaModel.generate(model: settings.selectedModel, prompt: prompt)
                    }
                }

            if (ollamaModel.isGenerating ?? false) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.small)
                    .padding(.leading)
            }
        }
    }
    
    // MARK: - TextEditorView
    private var TextEditorView: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $ollamaModel.response)
                .font(.title2)
                .frame(maxHeight: 500)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.automatic)
        }
    }
    
    // MARK: - ButtonsView
    private var ButtonsView: some View {
        HStack {
            Button(action: ollamaModel.response.copyToPasteboard) {
                Label("Copy", systemImage: "doc.on.doc")
            }
            .buttonStyle(.borderless)
            .padding([.trailing])
            
            Button(action: {
                // Remove the response and the prompt
                ollamaModel.clear()
                prompt = ""

                // Resize the window
                if let window = NSApp.keyWindow {
                    let frame = window.frame
                    window.setFrame(NSRect(x: frame.minX, y: frame.maxY, width: frame.width, height: 10), display: true, animate: false)
                }
            }) {
                Label("Clear", systemImage: "delete.left")
            }
            .buttonStyle(.borderless)
        }
    }
}

#Preview {
    SpotlightView()
}
