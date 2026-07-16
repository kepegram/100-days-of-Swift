//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Kadin Pegram on 7/15/26.
//

import Foundation

@Observable
class Favorites {
    private var resorts: Set<String>
    private let key = "Favorites"

    init() {
        if let saved = UserDefaults.standard.array(forKey: key) as? [String] {
            resorts = Set(saved)
        } else {
            resorts = []
        }
    }

    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }

    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }

    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }

    func save() {
        let saved = Array(resorts)
        UserDefaults.standard.set(saved, forKey: key)
    }
}
