//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Kadin Pegram on 7/13/26.
//

import SwiftUI

struct ContentView: View {
    enum SortType: String, CaseIterable, Identifiable {
        case `default` = "Default"
        case alphabetical = "Alphabetical"
        case country = "Country"
        var id: Self { self }
    }

    @State private var searchText = ""
    @State private var favorites = Favorites()
    @State private var sortType: SortType = .default
    
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    var filteredResorts: [Resort] {
        if searchText.isEmpty {
            resorts
        } else {
            resorts.filter{ $0.name.localizedStandardContains(searchText) }
        }
    }

    var sortedResorts: [Resort] {
        switch sortType {
        case .default:
            return filteredResorts
        case .alphabetical:
            return filteredResorts.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
        case .country:
            return filteredResorts.sorted { lhs, rhs in
                if lhs.country == rhs.country {
                    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
                } else {
                    return lhs.country.localizedStandardCompare(rhs.country) == .orderedAscending
                }
            }
        }
    }
    
    var body: some View {
        NavigationSplitView {
            List(sortedResorts) { resort in
                NavigationLink(value: resort) {
                    HStack {
                        Image(resort.country)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 25)
                            .clipShape(
                                .rect(cornerRadius: 5)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                        VStack(alignment: .leading) {
                            Text(resort.name)
                                .font(.headline)
                            Text("\(resort.runs) runs")
                                .foregroundStyle(.secondary)
                        }
                        
                        if favorites.contains(resort) {
                            Spacer()
                            Image(systemName: "heart.fill")
                            .accessibilityLabel("This is a favorite resort")
                                .foregroundStyle(.red)
                        }
                    }
                }
            }
            .navigationTitle("Resorts")
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort)
            }
            .searchable(text: $searchText, prompt: "Search for a resort")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Menu {
                        Picker("Sort Order", selection: $sortType) {
                            Text("Default").tag(SortType.default)
                            Text("Alphabetical").tag(SortType.alphabetical)
                            Text("Country").tag(SortType.country)
                        }
                    } label: {
                        Label("Sort", systemImage: "arrow.up.arrow.down")
                    }
                }
            }
        } detail: {
            WelcomeView()
        }
        .environment(favorites)
    }
}

#Preview {
    ContentView()
}
