//
//  ContentView.swift
//  RPS-Training
//
//  Created by Kadin Pegram on 2/11/26.
//

import SwiftUI

struct ContentView: View {
    @State private var moves = ["Rock", "Paper", "Scissors"]
    @State private var winningMoves = ["Paper", "Scissors", "Rock"]
    @State private var condition = ["Win", "Lose"]
    
    @State private var systemMove = ""
    @State private var systemCondition = ""
    
    @State private var selectedChoice = ""
    @State private var score = 0
    @State private var question = 0
    
    var body: some View {
        VStack {
            
            if question < 10 {
                Text("Question \(question + 1)")
                Text("I Choose \(systemMove)")
                    .font(.largeTitle)
                    .bold()
                Text("Your Goal: \(systemCondition)")
                
                HStack {
                    ForEach(moves, id: \.self) { choice in
                        Button(choice) {
                            verify(choice)
                        }
                    }
                }
                .padding()
                
            } else {
                Text("Game Over")
                    .font(.largeTitle)
                    .bold()
                
                Text("Final Score: \(score)")
                    .font(.title)
                
                Button("Play Again") {
                    resetGame()
                }
                .padding()
            }
        }
        .onAppear {
            generateRandomMove()
        }
    }
    
    func generateRandomMove() {
        systemMove = moves.randomElement()!
        systemCondition = condition.randomElement()!
    }

    func verify(_ choice: String) {
        selectedChoice = choice
        
        let systemIndex = moves.firstIndex(of: systemMove)!
        let correctWinningMove = winningMoves[systemIndex]
        let correctLosingMove = moves[(systemIndex + 2) % 3]
            
        var isCorrect = false
            
        if systemCondition == "Win" {
            isCorrect = choice == correctWinningMove
        } else {
            isCorrect = choice == correctLosingMove
        }
            
        if isCorrect {
            score += 1
        } else {
            score -= 1
        }
            
        question += 1
        
        if question < 10 {
            generateRandomMove()
        }
    }
    
    func resetGame() {
        score = 0
        question = 0
        generateRandomMove()
    }
}

#Preview {
    ContentView()
}
