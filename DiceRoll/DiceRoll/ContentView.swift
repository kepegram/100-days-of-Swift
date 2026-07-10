//
//  ContentView.swift
//  DiceRoll
//
//  Created by Kadin Pegram on 7/10/26.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @State private var showingCustomize = false
    @State private var selectedSides = 6
    @State private var diceAmount = 2
    @State private var rollResults: [Int] = []
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Selection")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("Rolling \(diceAmount) × d\(selectedSides)")
                        .font(.title2).bold()
                }
                
                if !rollResults.isEmpty {
                    Text("Total: \(rollResults.reduce(0, +))")
                        .font(.headline)
                        .transition(.opacity)
                }

                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        if !rollResults.isEmpty {
                            Text("Results: \(rollResults.map(String.init).joined(separator: ", "))")
                                .font(.body)
                                .monospacedDigit()
                        } else {
                            Text("Results: –")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 4)
                }
                
                Button(action: rollDice) {
                    Text("Roll Dice")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                       
                }
            }
            .padding()
            .navigationTitle("DiceRoll!")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Customize") {
                        showingCustomize = true
                    }
                }
            }
        }
        .sheet(isPresented: $showingCustomize) {
            CustomizeView(selectedSides: $selectedSides, diceAmount: $diceAmount)
        }
    }
    
    private func rollDice() {
        let results = (0..<diceAmount).map { _ in Int.random(in: 1...selectedSides) }
        rollResults = results

        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        let notifier = UINotificationFeedbackGenerator()
        notifier.notificationOccurred(.success)
    }
}

#Preview {
    ContentView()
}
