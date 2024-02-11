//
//  HistoryItemView.swift
//  OllamaSpotlight
//
//  Created by Oleg Rybalko on 11.02.2024.
//

import SwiftUI

struct HistoryItemView: View {
    @EnvironmentObject var history: History
    @Environment(\.presentationMode) var presentationMode
    @State var item: HistoryItem
    
    init(_ item: HistoryItem) {
        _item = State(initialValue: item)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(item.prompt.capitalized)
                .font(.title)
                .bold()
                .padding([.top, .bottom])
            
            TextEditor(text: $item.response)
                .font(.title2)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.automatic)
        
            ButtonsView
            
        }
        .padding()
    }
    
    private var ButtonsView: some View {
        HStack {
            Button("Copy", systemImage: "doc.on.doc", action: item.response.copyToPasteboard)
                .buttonStyle(.borderless)
                .padding(.trailing)
        
            Button("Delete", systemImage: "trash") {
                Task {
                    try? await history.delete(item)
                }
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(.borderless)
        }
    }
}

#Preview {
    HistoryItemView(HistoryItem(model: "test", prompt: "test", response: "here is a response"))
}
