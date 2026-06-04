//
//  Person.swift
//  RememberMe
//
//  Created by Kadin Pegram on 6/3/26.
//

import Foundation
import SwiftUI

struct Person: Identifiable, Codable {
    let id: UUID
    let name: String
    let imageData: Data
    let latitude: Double
    let longitude: Double
}

struct PersonCard: View {
    let person: Person

    var body: some View {
        VStack(spacing: 0) {
            if let uiImage = UIImage(data: person.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 160, height: 160)
                    .clipped()
            }

            Text(person.name)
                .font(.headline)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
        }
        .frame(width: 160)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 3)
    }
}
