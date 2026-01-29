//
//  ContentView.swift
//  Conversions
//
//  Created by Kadin Pegram on 1/29/26.
//

import SwiftUI

struct ContentView: View {
    @State private var inputValue = 0.0
    @State private var inputUnit = "Celsius"
    @State private var outputUnit = "Fahrenheit"
    
    let units = ["Celsius", "Fahrenheit", "Kelvin"]
    
    var outputValue: Double {
        let celsiusValue: Double
        
        switch inputUnit {
        case "Fahrenheit":
            celsiusValue = (inputValue - 32) * 5 / 9
        case "Kelvin":
            celsiusValue = inputValue - 273.15
        default:
            celsiusValue = inputValue
        }
        
        switch outputUnit {
        case "Fahrenheit":
            return celsiusValue * 9 / 5 + 32
        case "Kelvin":
            return celsiusValue + 273.15
        default:
            return celsiusValue
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Convert From") {
                    TextField("Value", value: $inputValue, format: .number)
                        .keyboardType(.decimalPad)
                    
                    Picker("Input Unit", selection: $inputUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                }
                
                Section("To") {
                    Picker("Output Unit", selection: $outputUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                    
                    Text(outputValue, format: .number.precision(.fractionLength(1)))
                }
            }
            .navigationTitle("Temp Conversions!")
        }
    }
}

#Preview {
    ContentView()
}
