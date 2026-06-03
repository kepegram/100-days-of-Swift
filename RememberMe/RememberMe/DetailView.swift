//
//  DetailView.swift
//  RememberMe
//
//  Created by Kadin Pegram on 6/3/26.
//

import SwiftUI

struct DetailView: View {
    let person: Person

    var body: some View {
        VStack(spacing: 20) {

            if let uiImage = UIImage(data: person.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }

            Text(person.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()
        }
        .padding()
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let uiImage = UIImage(systemName: "person.circle.fill")!
    let data = uiImage.jpegData(compressionQuality: 1.0)!

    let mockPerson = Person(
        id: UUID(),
        name: "John Doe",
        imageData: data
    )

    NavigationStack {
        DetailView(person: mockPerson)
    }
}
