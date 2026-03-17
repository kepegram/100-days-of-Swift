//
//  CrewView.swift
//  Moonshot
//
//  Created by Kadin Pegram on 3/17/26.
//

import SwiftUI

struct CrewView: View {
    let crew: [MissionView.CrewMember]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(crew, id: \.astronaut.id) { crewMember in
                    NavigationLink {
                        AstronautView(astronaut: crewMember.astronaut)
                    } label: {
                        HStack {
                            Image(crewMember.astronaut.id)
                                .resizable()
                                .frame(width: 104, height: 72)
                                .clipShape(.capsule)
                                .overlay(
                                    Capsule()
                                        .strokeBorder(.white, lineWidth: 1)
                                )

                            VStack(alignment: .leading) {
                                Text(crewMember.astronaut.name)
                                    .font(.headline)
                                    .foregroundStyle(.white)

                                Text(crewMember.role)
                                    .foregroundStyle(.white.opacity(0.5))
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
    }
}

#Preview {
    let missions: [Mission] = Bundle.main.decode("missions.json")
    let astronauts: [String: Astronaut] = Bundle.main.decode("astronauts.json")

    let crew = missions[1].crew.map { member in
        if let astronaut = astronauts[member.name] {
            return MissionView.CrewMember(
                role: member.role,
                astronaut: astronaut
            )
        } else {
            fatalError("Missing \(member.name)")
        }
    }

    return CrewView(crew: crew)
        .preferredColorScheme(.dark)
}
