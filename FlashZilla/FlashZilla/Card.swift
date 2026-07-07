//
//  Card.swift
//  FlashZilla
//
//  Created by Kadin Pegram on 6/30/26.
//

import Foundation

struct Card: Codable, Identifiable {
    var id: UUID
    var prompt: String
    var answer: String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
    
    init(id: UUID = UUID(), prompt: String, answer: String) {
        self.id = id
        self.prompt = prompt
        self.answer = answer
    }
    
    enum CodingKeys: CodingKey {
        case id, prompt, answer
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        prompt = try container.decode(String.self, forKey: .prompt)
        answer = try container.decode(String.self, forKey: .answer)
    }
}

enum CardStore {
    static let savePath = URL.documentsDirectory.appending(path: "cards.json")
    
    static func load() -> [Card] {
        do {
            let data = try Data(contentsOf: savePath)
            return try JSONDecoder().decode([Card].self, from: data)
        } catch {
            return loadLegacyCards()
        }
    }
    
    static func save(_ cards: [Card]) {
        do {
            let data = try JSONEncoder().encode(cards)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save card data.")
        }
    }
    
    private static func loadLegacyCards() -> [Card] {
        guard let data = UserDefaults.standard.data(forKey: "Cards") else {
            return []
        }
        
        do {
            let cards = try JSONDecoder().decode([Card].self, from: data)
            save(cards)
            UserDefaults.standard.removeObject(forKey: "Cards")
            return cards
        } catch {
            return []
        }
    }
}
