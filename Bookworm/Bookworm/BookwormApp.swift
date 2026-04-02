//
//  BookwormApp.swift
//  Bookworm
//
//  Created by Kadin Pegram on 4/1/26.
//

import SwiftData
import SwiftUI

@main
struct BookwormApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Book.self)
    }
}
