//
//  HabitDetailView.swift
//  Habits
//
//  Created by Kadin Pegram on 3/24/26.
//

import SwiftUI

struct HabitDetailView: View {
    let habit: Habit
    
    var body: some View {
        VStack {
            Text(habit.name)
                .font(.largeTitle)
            Text(habit.description)
                .font(.subheadline)
        }
        .navigationTitle("\(habit.name) Habit")
    }
}

#Preview {
    HabitDetailView(habit: Habit(name: "Habit 1", description: "This is my first habit!"))
}
