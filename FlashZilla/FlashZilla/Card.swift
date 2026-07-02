//
//  Card.swift
//  FlashZilla
//
//  Created by Kadin Pegram on 6/30/26.
//

import Foundation

struct Card: Codable {
    var prompt: String
    var answer: String
    
    static let example = Card(prompt: "Who played the 13th Doctor in Doctor Who?", answer: "Jodie Whittaker")
}
