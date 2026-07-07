//
//  CardView.swift
//  FlashZilla
//
//  Created by Kadin Pegram on 6/30/26.
//

import SwiftUI

struct SwipeCardBackground: ViewModifier {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    
    let offset: CGSize
    
    var backgroundColor: Color {
        if accessibilityDifferentiateWithoutColor {
            return .white
        } else if offset.width == 0 {
            return .white
        } else if offset.width > 0 {
            return .green
        } else {
            return .red
        }
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(
                accessibilityDifferentiateWithoutColor
                ? .white
                : .white
                    .opacity(1 - Double(abs(offset.width / 50)))
            )
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(backgroundColor)
            )
    }
}

struct CardView: View {
    @Environment(\.accessibilityDifferentiateWithoutColor) var accessibilityDifferentiateWithoutColor
    @State private var offset = CGSize.zero
    @State private var isShowingAnswer = false
    
    let card: Card
    var removal: ((Bool) -> Void)? = nil
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .modifier(SwipeCardBackground(offset: offset))
                .shadow(radius: 10)
            
            VStack {
                Text(card.prompt)
                    .font(.largeTitle)
                    .foregroundStyle(.black)
                
                if isShowingAnswer {
                    Text(card.answer)
                        .font(.title)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(width: 450, height: 250)
        .rotationEffect(.degrees(offset.width / 5.0))
        .offset(x: offset.width * 5)
        .opacity(2 - Double(abs(offset.width / 50)))
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        removal?(offset.width > 0)
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            isShowingAnswer.toggle()
        }
        .animation(.bouncy, value: offset)
    }
}

#Preview {
    CardView(card: .example)
}
