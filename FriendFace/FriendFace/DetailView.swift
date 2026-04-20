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
                        .bold()

                    Circle()
                        .fill(user.isActive ? .green : .red)
                        .frame(width: 10, height: 10)

                    Text("Age: \(user.age)")
                        .foregroundStyle(.secondary)

                    Text(user.company)
                        .font(.headline)
                }

                VStack(alignment: .leading, spacing: 10) {
                    Text("Friends")
                        .font(.title2)
                        .bold()

                    ForEach(user.friends) { friend in
                        HStack {
                            Circle()
                                .fill(.blue.opacity(0.3))
                                .frame(width: 30, height: 30)

                            Text(friend.name)

                            Spacer()
                        }
                    }
                }
                .padding()
            }
            .padding()
        }
        .navigationTitle("Profile")
    }
}

#Preview {
    let friend1 = Friend(id: "2", name: "Jane Smith")
    let friend2 = Friend(id: "3", name: "Bob Johnson")

    let user = User(
        id: "1",
        name: "John Doe",
        age: 30,
        company: "Apple",
        isActive: true,
        friends: [friend1, friend2]
    )

    NavigationStack {
        DetailView(user: user)
    }
}
