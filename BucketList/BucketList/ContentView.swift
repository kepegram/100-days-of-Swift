//
//  ContentView.swift
//  BucketList
//
//  Created by Kadin Pegram on 6/1/26.
//

import MapKit
import SwiftUI

struct ContentView: View {
    let startPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 56, longitude: -3),
            span: MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        )
    )

    @State private var isHybrid = false
    @State private var locations = [Location]()
    @State private var selectedPlace: Location?

    var body: some View {
        MapReader { proxy in
            ZStack(alignment: .topTrailing) {
                Map(initialPosition: startPosition) {
                    ForEach(locations) { location in
                        Annotation(
                            location.name,
                            coordinate: location.coordinate
                        ) {
                            Image(systemName: "star.circle")
                                .resizable()
                                .foregroundStyle(.red)
                                .frame(width: 44, height: 44)
                                .background(.white)
                                .clipShape(.circle)
                                .onLongPressGesture {
                                    selectedPlace = location
                                }
                        }
                    }
                }
                .mapStyle(isHybrid ? .hybrid : .standard)

                Button("Change Map Style") {
                    isHybrid.toggle()
                }
                .padding()
                .buttonStyle(.borderedProminent)
                .sheet(item: $selectedPlace) { place in
                    EditView(location: place) { newLocation in
                        if let index = locations.firstIndex(of: place) {
                            locations[index] = newLocation
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
