//
//  Mission.swift
//  Moonshot
//
//  Created by Kadin Pegram on 3/13/26.
//

import Foundation

struct CrewRole: Codable, Hashable {
    let name: String
    let role: String
}

struct Mission: Codable, Identifiable, Hashable {
    let id: Int
    let launchDate: Date?
    let crew: [CrewRole]
    let description: String
    
    var displayName: String {
        "Apollo \(id)"
    }
    
    var image: String {
        "apollo\(id)"
    }
    
    var formattedLaunchDate: String {
        launchDate?.formatted(date: .abbreviated, time: .omitted) ?? "N/A"
    }
}
