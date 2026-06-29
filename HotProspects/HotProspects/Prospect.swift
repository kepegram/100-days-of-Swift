//
//  Prospect.swift
//  HotProspects
//
//  Created by Kadin Pegram on 6/29/26.
//

import Foundation
import SwiftData

@Model
class Prospect {
    var name: String
    var emailAddress: String
    var isContacted: Bool
    var dateAdded: Date = Date.now
    
    init(name: String, emailAddress: String, isContacted: Bool, dateAdded: Date = Date.now) {
        self.name = name
        self.emailAddress = emailAddress
        self.isContacted = isContacted
        self.dateAdded = dateAdded
    }
}
