//
//  ContentView.swift
//  iExpense
//
//  Created by Kadin Pegram on 3/9/26.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable  {
    var id = UUID()
    let name: String
    let type: String
    let amount: Double
}

@Observable
class Expenses {
    var items = [ExpenseItem]() {
        didSet {
            if let encoded = try? JSONEncoder().encode(items) {
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) {
                items = decodedItems
                return
            }
        }
        
        items = []
    }
}

struct ContentView: View {
    @State private var expenses = Expenses()
    
    var body: some View {
        NavigationStack {
            List {
                Section("Personal") {
                    ForEach(expenses.items.filter { $0.type == "Personal" }) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundStyle(amountColor(for: item.amount))
                        }
                    }
                    .onDelete(perform: removePersonalItems)
                }
                
                Section("Business") {
                    ForEach(expenses.items.filter { $0.type == "Business" }) { item in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(item.name)
                                    .font(.headline)
                                Text(item.type)
                            }
                            
                            Spacer()
                            
                            Text(item.amount, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                .foregroundStyle(amountColor(for: item.amount))
                        }
                    }
                    .onDelete(perform: removeBusinessItems)
                }
            }
            .navigationTitle("iExpense")
            .toolbar {
                NavigationLink("Add Expense") {
                    AddView(expenses: expenses)
                }
            }
        }
    }
    
    func amountColor(for amount: Double) -> Color {
        if amount < 10 {
            return .green
        } else if amount < 100 {
            return .orange
        } else {
            return .red
        }
    }
    
    func removePersonalItems(at offsets: IndexSet) {
        let personalItems = expenses.items.filter { $0.type == "Personal" }
        let itemsToRemove = offsets.map { personalItems[$0] }
        
        for item in itemsToRemove {
            if let index = expenses.items.firstIndex(where: { $0.id == item.id }) {
                expenses.items.remove(at: index)
            }
        }
    }
    
    func removeBusinessItems(at offsets: IndexSet) {
        let businessItems = expenses.items.filter { $0.type == "Business" }
        let itemsToRemove = offsets.map { businessItems[$0] }
        
        for item in itemsToRemove {
            if let index = expenses.items.firstIndex(where: { $0.id == item.id }) {
                expenses.items.remove(at: index)
            }
        }
    }
}

#Preview {
    ContentView()
}
