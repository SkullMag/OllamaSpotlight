//
//  ContentView.swift
//  OllamaSearch
//
//  Created by Oleg Rybalko on 05.02.2024.
//

import SwiftUI
import AppKit


struct ContentView: View {
    @StateObject private var searchModel = OllamaSearchModel()
    @State private var prompt: String = ""
    
    @ViewBuilder
    var body: some View {
        VStack(alignment: .leading) {
            if searchModel.isGenerating == nil {
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
                
                if !searchModel.isGenerating! {
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
                        await searchModel.generate(model: "llama2:7b", prompt: prompt)
                    }
                }
            
            if (searchModel.isGenerating ?? false) {
                ProgressView()
                    .progressViewStyle(.circular)
                    .controlSize(.small)
            }
        }
    }
    
    // MARK: - TextEditorView
    private var TextEditorView: some View {
        VStack(alignment: .leading) {
            TextEditor(text: $searchModel.response)
                .font(.title2)
                .frame(maxHeight: 500)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .scrollIndicators(.automatic)
        }
    }
    
    private var ButtonsView: some View {
        HStack {
            Button(action: copyToClipboard) {
                Label("Copy", systemImage: "doc.on.doc")
            }
            .buttonStyle(.borderless)
            .padding([.trailing])
            
            Button(action: {}) {
                Label("Share", systemImage: "square.and.arrow.up")
            }
            .buttonStyle(.borderless)
            .padding([.trailing])

            Button(action: {
                // Remove the response
                searchModel.clear()

                // Resize the window
                if let window = NSApp.mainWindow {
                    let frame = window.frame
                    window.setFrame(NSRect(x: frame.minX, y: frame.maxY, width: frame.width, height: 10), display: true, animate: false)
                }
            }) {
                Label("Clear", systemImage: "delete.left")
            }
            .buttonStyle(.borderless)
        }
    }
    
    private func copyToClipboard() {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([.string], owner: nil)
        pasteboard.setString(searchModel.response, forType: .string)
    }
}

#Preview {
    ContentView()
}
