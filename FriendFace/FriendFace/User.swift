//
//  User.swift
//  FriendFace
//
//  Created by Kadin Pegram on 4/16/26.
//

import Foundation
import SwiftData

@Model
class User {
    var id: String
    var name: String
    var age: Int
    var company: String
    var isActive: Bool

    @Relationship(deleteRule: .cascade)
    var friends: [Friend]

    init(
        id: String,
        name: String,
        age: Int,
        company: String,
        isActive: Bool,
        friends: [Friend] = []
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.company = company
        self.isActive = isActive
        self.friends = friends
    }
}

@Model
class Friend {
    var id: String
    var name: String

    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

struct UserDTO: Codable {
    let id: String
    let name: String
    let age: Int
    let company: String
    let isActive: Bool
    let friends: [FriendDTO]
}

struct FriendDTO: Codable {
    let id: String
    let name: String
}
