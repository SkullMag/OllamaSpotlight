//
//  ContentView.swift
//  OllamaSearch
//
//  Created by Oleg Rybalko on 05.02.2024.
//

import SwiftUI
import AppKit


struct ContentView: View {
    @State private var prompt: String = "where does llama live?"
    @StateObject private var searchModel = OllamaSearchModel()
    
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
                .frame(maxHeight: 500)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .scrollIndicators(.automatic)
        }
    }
    
    private var ButtonsView: some View {
        HStack {
            Button(action: copyToClipboard) {
                Label("Copy to Clipboard", systemImage: "doc.on.doc")
            }
            .buttonStyle(.borderless)
            
            Button(action: {}) {
                Label("Share", systemImage: "square.and.arrow.up")
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
