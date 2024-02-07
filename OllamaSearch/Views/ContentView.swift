//
//  ContentView.swift
//  OllamaSearch
//
//  Created by Oleg Rybalko on 05.02.2024.
//

import SwiftUI
import AppKit


struct ContentView: View {
    @State private var prompt: String = ""
    @StateObject var searchModel = OllamaSearchModel()
    
    @ViewBuilder
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            VStack(alignment: .leading) {
                TextHeaderView
                
                if (searchModel.isGenerating != nil) {
                    TextEditorView
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                }
                
            }
            
            if (!(searchModel.isGenerating ?? true)) {
                Button(action: copyToClipboard) {
                    Label("Copy to Clipboard", systemImage: "doc.on.doc")
                }
                .buttonStyle(.borderless)
            }
            
            Spacer()
        }
        .padding([.leading, .trailing])
    }
    
    // MARK: - TextHeaderView
    private var TextHeaderView: some View {
        HStack(alignment: .center) {
            TextField("Where does llama live?", text: $prompt)
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
                .frame(maxHeight: 300)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .scrollIndicators(.never)
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
