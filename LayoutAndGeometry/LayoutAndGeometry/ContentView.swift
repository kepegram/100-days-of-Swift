//
//  ContentView.swift
//  LayoutAndGeometry
//
//  Created by Kadin Pegram on 7/8/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader { fullView in
            ScrollView(.vertical) {
                ForEach(0..<50) { index in
                    GeometryReader { proxy in
                        Text("Row #\(index)")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .background(Color(
                                hue: min(proxy.frame(in: .global).minY / fullView.size.height, 1),
                                saturation: 1,
                                brightness: 1
                            ))
                            .rotation3DEffect(
                                .degrees(
                                    proxy.frame(in: .global).minY - fullView
                                        .size.height / 2
                                ) / 5,
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .opacity(min(proxy.frame(in: .global).minY / 200, 1))
                            .scaleEffect(min(proxy.frame(in: .global).minY / 200, 1))
                    }
                    .frame(height: 40)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
