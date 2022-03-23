//
//  Cardify.swift
//  SetGame
//
//  Created by Zhibek Rahymbekkyzy on 07.02.2022.
//

import SwiftUI

struct Neonifier: ViewModifier {
    let isMatched: Bool
    var color: Color {
        if(isMatched) {
            return .green
        } else {
            return .red
        }
    }
    let blurRadius: CGFloat = 5
    
    func body(content: Content) -> some View {
        return ZStack {
            content.foregroundColor(color)
            content.blur(radius: blurRadius)
        }
        .padding(10)
        .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(color, lineWidth: 4))
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(color, lineWidth: 4).brightness(0.1).blur(radius: blurRadius))
        .background(RoundedRectangle(cornerRadius: 16, style: .continuous).stroke(color, lineWidth: 4).brightness(0.1).blur(radius: blurRadius).opacity(0.2))
        .compositingGroup()
    }
}

extension View {
    func neonify(isMatched: Bool) -> some View {
        self.modifier(Neonifier(isMatched: isMatched))
    }
}
