//
//  ContentView.swift
//  iExpense
//
//  Created by Kadin Pegram on 3/9/26.
//

import SwiftData
import SwiftUI

@Model
class ExpenseItem {
    var name: String
    var type: String
    var amount: Double

    init(name: String, type: String, amount: Double) {
        self.name = name
        self.type = type
        self.amount = amount
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var expenses: [ExpenseItem]

    @State private var selectedFilter = "All"
    @State private var selectedSort = "Name"

    let filters = ["All", "Personal", "Business"]
    let sorts = ["Name", "Amount"]

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredAndSortedExpenses) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }

                        Spacer()

                        Text(
                            item.amount,
                            format: .currency(
                                code: Locale.current.currency?.identifier
                                    ?? "USD"
                            )
                        )
                        .foregroundStyle(amountColor(for: item.amount))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu("Filter") {
                        Picker("Filter", selection: $selectedFilter) {
                            ForEach(filters, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }

                ToolbarItem(placement: .topBarLeading) {
                    Menu("Sort") {
                        Picker("Sort", selection: $selectedSort) {
                            ForEach(sorts, id: \.self) {
                                Text($0)
                            }
                        }
                    }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink("Add Expense") {
                        AddView()
                    }
                }
            }
        }
    }

    var filteredAndSortedExpenses: [ExpenseItem] {
        var result = expenses

        if selectedFilter != "All" {
            result = result.filter { $0.type == selectedFilter }
        }

        if selectedSort == "Name" {
            result.sort { $0.name < $1.name }
        } else {
            result.sort { $0.amount < $1.amount }
        }

        return result
    }

    func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            let item = filteredAndSortedExpenses[index]
            modelContext.delete(item)
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
}

#Preview {
    ContentView()
        .modelContainer(for: ExpenseItem.self)
}
