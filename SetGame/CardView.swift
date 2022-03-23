//
//  CardView.swift
//  SetGame
//
//  Created by Zhibek Rahymbekkyzy on 04.02.2022.
//

import SwiftUI

struct CardView: View {
    let card: SetDeckGame.Card
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack{
                let shape = RoundedRectangle(cornerRadius: DrawingConstants.cornerRadius)
                shape.fill().foregroundColor(.white)
                VStack {
                    ForEach(0..<howMany) {_ in
                        self.drawShapes(shape: card.CardShape, height: geometry.size.height, width: geometry.size.width)
                    }
                }
                if card.isTouched{
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                        .padding(5).foregroundColor(.green)
                } else {
                    shape.strokeBorder(lineWidth: DrawingConstants.lineWidth)
                        .padding(5).foregroundColor(.black)
                }
            }
        }
    }
    
    var howMany: Int {
        switch card.CardNumber{
        case .one: return 1
        case .two: return 2
        case .three: return 3
        }
    }
    
    var opacity: CGFloat {
        switch card.CardShading {
        case .full, .open: return 1
        case .half: return 0.3
        }
    }
    
    var color: Color {
        switch card.CardColor {
        case .purple: return .purple
        case .green: return .green
        case .red: return .red
        }
    }
    
    var stroke: CGFloat? {
        switch card.CardShading {
        case .full, .half: return nil
        case .open: return 1
        }
    }
    
    @ViewBuilder
    func drawShapes(shape: SetGame.Card.shape, height: CGFloat, width: CGFloat) -> some View {
        switch card.CardShape {
        case .squiggle:
            ZStack{
                Squiggle().aspectRatio(4/3, contentMode: .fit).foregroundColor(color).opacity(opacity).frame(width: width/2, height: height/5)
                if card.CardShading == .open{
                    Squiggle().fill(.white).opacity(1).aspectRatio(4/1.5, contentMode: .fit).frame(width: width/2, height: height/5)
                }
                }
                
        case .rectangle:
            if let strokeWidth = stroke {
            Rectangle().strokeBorder(lineWidth: strokeWidth).opacity(opacity)
                .foregroundColor(color)
                .aspectRatio(2/1, contentMode: .fit)
                .frame(width: width/2, height: height/5)
            } else  {
                Rectangle().opacity(opacity)
                    .foregroundColor(color)
                    .aspectRatio(2/1, contentMode: .fit)
                    .frame(width: width/2, height: height/5)
            }
        case .oval:
            if let strokeWidth = stroke {
            Capsule().strokeBorder(lineWidth: strokeWidth).opacity(opacity).foregroundColor(color).aspectRatio(2/1, contentMode: .fit).frame(width: width/2, height: height/5)
            } else {
                Capsule().opacity(opacity).foregroundColor(color).aspectRatio(2/1, contentMode: .fit).frame(width: width/2, height: height/5)
            }
        }
    }
}
