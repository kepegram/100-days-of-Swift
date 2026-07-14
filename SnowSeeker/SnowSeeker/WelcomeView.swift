//
//  WelcomeView.swift
//  SnowSeeker
//
//  Created by Kadin Pegram on 7/14/26.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker")
                .font(.largeTitle)
            
            Text("Please select a restort from the left-hand menu; swipe from the edge to show it.")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    WelcomeView()
}
