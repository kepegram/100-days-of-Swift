//
//  ContentView.swift
//  Edutainment
//
//  Created by Kadin Pegram on 3/6/26.
//

import SwiftUI

struct Question {
    let text: String
    let answer: Int
}

struct ContentView: View {
    @State private var table = 2
    @State private var selectedQuestions = 5
    @State private var numOfQuestions = [5, 10, 20]
    
    @State private var isGameActive = false
    @State private var questions = [Question]()
    @State private var currentQuestionIndex = 0
    @State private var userAnswer = ""
    @State private var score = 0
    @State private var showingResults = false
    
    var body: some View {
        NavigationStack {
            if isGameActive {
                VStack(spacing: 40) {
                    Text("Question \(currentQuestionIndex + 1) of \(selectedQuestions)")
                        .font(.largeTitle)
                    
                    Text(questions[currentQuestionIndex].text)
                        .font(.system(size: 80, weight: .bold))
                    
                    TextField("Answer", text: $userAnswer)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                    
                    Button("Submit") {
                        checkAnswer()
                    }
                    .buttonStyle(.bordered)
                    .disabled(userAnswer.isEmpty)
                }
                .navigationTitle("Solve!")
                .alert("Game Over", isPresented: $showingResults) {
                    Button("Play Again!") { resetGame() }
                } message: {
                    Text("Your final score is \(score) / \(selectedQuestions)")
                }
            } else {
                Form {
                    Section("Game Settings") {
                        Picker("Multiplication Table", selection: $table) {
                            ForEach(2...12, id: \.self) {
                                Text("\($0) times")
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Number of Questions")
                                .font(.headline)
                            Picker("Questions", selection: $selectedQuestions) {
                                ForEach(numOfQuestions, id: \.self) {
                                    Text("\($0)")
                                }
                            }
                            .pickerStyle(.segmented)
                        }
                    }
                }
                .navigationTitle("Edutainment!")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Generate") {
                            generateQuestions()
                            isGameActive = true
                        }
                    }
                }
            }
        }
    }
    
    func generateQuestions() {
        questions.removeAll()

        for _ in 0..<selectedQuestions {
            let multiplier = Int.random(in: 1...12)
            let questionText = "\(table) x \(multiplier)"
            let answer = table * multiplier

            questions.append(Question(text: questionText, answer: answer))
        }
    }
    
    func checkAnswer() {
        if Int(userAnswer) == questions[currentQuestionIndex].answer {
            score += 1
        }
        
        if currentQuestionIndex + 1 < questions.count {
            currentQuestionIndex += 1
            userAnswer = ""
        } else {
            showingResults = true
        }
    }
    
    func resetGame() {
        isGameActive = false
        userAnswer = ""
        score = 0
        currentQuestionIndex = 0
    }
}

#Preview {
    ContentView()
}
