//
//  ContentView.swift
//  RememberMe
//
//  Created by Kadin Pegram on 6/3/26.
//
import PhotosUI
import SwiftUI

struct ContentView: View {
    @State private var people: [Person] = []
    @State private var selectedItem: PhotosPickerItem?

    @State private var showingNamePrompt = false
    @State private var newImageData: Data?
    @State private var newImageName = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {

                PhotosPicker(selection: $selectedItem, matching: .images) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)

                        Text("Add Photo")
                            .font(.headline)

                        Spacer()
                    }
                    .padding()
                    .background(.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
                .padding(.horizontal)

                ScrollView {
                    LazyVGrid(
                        columns: [
                            GridItem(.adaptive(minimum: 140), spacing: 12)
                        ],
                        spacing: 12
                    ) {
                        ForEach(people) { person in
                            NavigationLink {
                                DetailView(person: person)
                            } label: {
                                PersonCard(person: person)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Remember Me")
            .background(Color(.systemGroupedBackground))
            .onChange(of: selectedItem, loadImage)
            .alert("Name this picture", isPresented: $showingNamePrompt) {
                TextField("Name", text: $newImageName)
                Button("Save", action: saveImage)
                Button("Cancel", role: .cancel) {}
            }
        }
    }

    func loadImage() {
        Task {
            guard
                let imageData = try await selectedItem?.loadTransferable(
                    type: Data.self
                )
            else { return }

            newImageData = imageData
            showingNamePrompt = true
        }
    }

    func saveImage() {
        guard let imageData = newImageData else { return }

        let person = Person(
            id: UUID(),
            name: newImageName,
            imageData: imageData
        )

        people.append(person)

        newImageName = ""
        newImageData = nil
        selectedItem = nil
    }
}

#Preview {
    ContentView()
}
