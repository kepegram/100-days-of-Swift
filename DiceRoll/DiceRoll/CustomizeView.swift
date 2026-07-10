//
//  CustomizeView.swift
//  DiceRoll
//
//  Created by Kadin Pegram on 7/10/26.
//

import SwiftUI

struct CustomizeView: View {
    let sides = [4, 6, 8, 10, 12, 20, 100]
    @Binding var selectedSides: Int
    @Binding var diceAmount: Int
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Dice Type") {
                    Picker("Number of sides", selection: $selectedSides) {
                        ForEach(sides, id: \.self) { value in
                            Text("d\(value)").tag(value)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section("Quantity") {
                    Stepper(value: $diceAmount, in: 1...20) {
                        HStack {
                            Text("Number of dice")
                            Spacer()
                            Text("\(diceAmount)")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                
                Section("Preview") {
                    HStack {
                        Text("Rolling")
                        Spacer()
                        Text("\(diceAmount) × d\(selectedSides)")
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Customize Dice")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    CustomizeView(selectedSides: .constant(4), diceAmount: .constant(2))
}
