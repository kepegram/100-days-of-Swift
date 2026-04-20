//
//  ContentView.swift
//  FriendFace
//
//  Created by Kadin Pegram on 4/16/26.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var users: [User]

    var body: some View {
        NavigationStack {
            List(users) { item in
                NavigationLink(value: item) {
                    HStack(spacing: 12) {
                        Circle()
                            .fill(item.isActive ? .green : .red)
                            .frame(width: 12, height: 12)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.name)
                                .font(.headline)

                            Text("Age \(item.age)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("FriendFace")
            .task {
                if users.isEmpty {
                    await loadData()
                }
            }
            .navigationDestination(for: User.self) { user in
                DetailView(user: user)
            }
        }
    }

    func loadData() async {
        guard
            let url = URL(
                string:
                    "https://www.hackingwithswift.com/samples/friendface.json"
            )
        else {
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            let decoded = try JSONDecoder().decode([UserDTO].self, from: data)

            for dto in decoded {
                let user = User(
                    id: dto.id,
                    name: dto.name,
                    age: dto.age,
                    company: dto.company,
                    isActive: dto.isActive
                )

                modelContext.insert(user)

                let friends = dto.friends.map {
                    Friend(id: $0.id, name: $0.name)
                }

                user.friends.append(contentsOf: friends)
            }

            try? modelContext.save()
        } catch {
            print("Failed to load data: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
