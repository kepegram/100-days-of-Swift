//
//  User.swift
//  FriendFace
//
//  Created by Kadin Pegram on 4/16/26.
//

import Foundation

struct User: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let age: Int
    let company: String
    let isActive: Bool
    let friends: [Friend]
}

struct Friend: Codable, Identifiable, Hashable {
    let id: String
    let name: String
}
