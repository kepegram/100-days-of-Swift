//
//  ContentView.swift
//  FriendFace
//
//  Created by Kadin Pegram on 4/16/26.
//

import SwiftUI

struct ContentView: View {
    @State private var users = [User]()

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

                            VStack {
                                Text("Age \(item.age)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 6)
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

            let decodedResponse = try JSONDecoder().decode(
                [User].self,
                from: data
            )
            users = decodedResponse
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
