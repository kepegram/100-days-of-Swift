//
//  AddView.swift
//  Habits
//
//  Created by Kadin Pegram on 3/24/26.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var title = "Title"
    @State private var description = "Description"
    
    var habits: Habits
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Title", text: $title)
                TextField("Description", text: $description)
            }
            .navigationTitle("Create habit")
            .toolbar {
                Button("Save") {
                    let item = Habit(name: title, description: description)
                    habits.items.append(item)
                    dismiss()
                }
            }
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    AddView(habits: Habits())
}
