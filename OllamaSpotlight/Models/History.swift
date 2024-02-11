//
//  History.swift
//  OllamaSpotlight
//
//  Created by Oleg Rybalko on 11.02.2024.
//

import Foundation
import Combine

struct HistoryItem: Codable, Identifiable, Hashable {
    var id = UUID()
    let model: String
    var prompt: String
    var response: String
}

class History: ObservableObject, Observable {
    @Published var items: [HistoryItem] = []
    
    init() {
        Task {
            do {
                try await load()
            } catch {
                print("failed to load history: \(error.localizedDescription)")
            }
        }
    }
    
    func save(model: String, prompt: String, response: String) {
        items.append(HistoryItem(model: model, prompt: prompt, response: response))
        
        Task {
            do {
                try await save()
            } catch {
                print("failed to save item: \(error.localizedDescription)")
            }
        }
    }
    
    func delete(_ item: HistoryItem) async throws {
        items.removeAll(where: { $0.id == item.id })
        try await save()
    }
    
    func load() async throws {
        let task = Task<[HistoryItem], Error> {
            let fileURL = try Self.fileURL()
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            return try JSONDecoder().decode([HistoryItem].self, from: data)
        }
        items = try await task.value
    }
    
    private func save() async throws {
        let task = Task {
            let data = try JSONEncoder().encode(items)
            let outfile = try Self.fileURL()
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    private static func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appending(path: "ollamaSpotlightHistory.data")
    }
}
