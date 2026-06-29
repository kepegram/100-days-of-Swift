//
//  HotProspectsApp.swift
//  HotProspects
//
//  Created by Kadin Pegram on 6/5/26.
//

import SwiftData
import SwiftUI

@main
struct HotProspectsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Prospect.self )
    }
}
