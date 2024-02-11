//
//  HistoryView.swift
//  OllamaSpotlight
//
//  Created by Oleg Rybalko on 11.02.2024.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject private var history: History
    @State private var selectedItem: HistoryItem?
    
    var body: some View {
        NavigationStack {
            if history.items.count == 0 {
                ZStack(alignment: .center) {
                    Text("Your history is empty")
                        .foregroundStyle(.secondary)
                        .padding()
                }
            } else {
                HistoryListView
                    .navigationDestination(item: $selectedItem) { item in
                        HistoryItemView(item)
                    }
            }
        }
    }
    
    // MARK: - HistoryListView
    private var HistoryListView: some View {
        List(history.items) { item in
            HistoryListItemView(item)
                .environment(history)
        }
        .task {
            try? await history.load()
        }
        .navigationDestination(for: HistoryItem.self) { dest in
            HistoryItemView(dest)
        }
    }
    
    // MARK: - HistoryListItemView
    private func HistoryListItemView(_ item: HistoryItem) -> some View {
        HStack {
            NavigationLink(item.prompt, value: item)
            .font(.title)
            .padding()
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .padding()
        }
    }
}

#Preview {
    HistoryView()
        .environment(History())
}
