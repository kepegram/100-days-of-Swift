//
//  DetailView.swift
//  RememberMe
//
//  Created by Kadin Pegram on 6/3/26.
//
import MapKit
import SwiftUI

struct DetailView: View {
    let person: Person

    @State private var cameraPosition: MapCameraPosition

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: person.latitude,
            longitude: person.longitude
        )
    }

    init(person: Person) {
        self.person = person

        let coordinate = CLLocationCoordinate2D(
            latitude: person.latitude,
            longitude: person.longitude
        )

        _cameraPosition = State(
            initialValue: .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(
                        latitudeDelta: 0.01,
                        longitudeDelta: 0.01
                    )
                )
            )
        )
    }

    var body: some View {
        VStack(spacing: 20) {

            if let uiImage = UIImage(data: person.imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
            }

            Text(person.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            Map(position: $cameraPosition) {
                Marker(person.name, coordinate: coordinate)
            }
            .frame(height: 300)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            Spacer()
        }
        .padding()
        .navigationTitle(person.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let uiImage = UIImage(systemName: "person.circle.fill")!
    let data = uiImage.jpegData(compressionQuality: 1.0)!

    let mockPerson = Person(
        id: UUID(),
        name: "John Doe",
        imageData: data,
        latitude: 37.3349,
        longitude: -122.0090
    )

    NavigationStack {
        DetailView(person: mockPerson)
    }
}
