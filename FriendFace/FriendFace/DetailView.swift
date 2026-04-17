//
//  DetailView.swift
//  FriendFace
//
//  Created by Kadin Pegram on 4/16/26.
//

import SwiftUI

struct DetailView: View {
    let user: User

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text(user.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)

                    HStack(spacing: 6) {
                        Circle()
                            .fill(user.isActive ? .green : .red)
                            .frame(width: 10, height: 10)

                        Text(user.isActive ? "Active" : "Offline")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Text("Age: \(user.age)")
                        .foregroundStyle(.secondary)

                    Text(user.company)
                        .font(.headline)
                }
                .padding()

                VStack(alignment: .leading, spacing: 10) {
                    Text("Friends")
                        .font(.title2)
                        .fontWeight(.semibold)

                    ForEach(user.friends) { friend in
                        HStack {
                            Circle()
                                .fill(.blue.opacity(0.3))
                                .frame(width: 30, height: 30)

                            Text(friend.name)

                            Spacer()
                        }
                        .padding(.vertical, 6)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DetailView(
        user: User(
            id: "1",
            name: "John Doe",
            age: 30,
            company: "Apple",
            isActive: false,
            friends: [
                Friend(id: "2", name: "Jane Smith"),
                Friend(id: "3", name: "Bob Johnson"),
            ]
        )
    )
}
