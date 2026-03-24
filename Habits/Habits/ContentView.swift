//
//  ContentView.swift
//  Habits
//
//  Created by Kadin Pegram on 3/24/26.
//

import SwiftUI

struct Habit: Identifiable, Codable, Hashable {
    var id = UUID()
    let name: String
    let description: String
}

@Observable
class Habits {
    var items = [Habit]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([Habit].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var habits = Habits()

    var body: some View {
        NavigationStack {
            List {
                Section("Habits") {
                    ForEach(habits.items) { item in
                        NavigationLink(value: item) {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.description)
                                    .font(.subheadline)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Habit Tracker!")
            .navigationDestination(for: Habit.self) { item in
                HabitDetailView(habit: item)
            }
            .toolbar {
                NavigationLink("Add Habit") {
                    AddView(habits: habits)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
