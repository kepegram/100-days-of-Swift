//
//  FriendFaceApp.swift
//  FriendFace
//
//  Created by Kadin Pegram on 4/16/26.
//

import SwiftData
import SwiftUI

@main
struct FriendFaceApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [User.self, Friend.self])
    }
}
