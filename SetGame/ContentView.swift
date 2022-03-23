//
//  ContentView.swift
//  SetGame
//
//  Created by Zhibek Rahymbekkyzy on 18.01.2022.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var game = SetDeckGame()
    
    @Namespace private var dealingNamespace
    
    var body: some View {
        ZStack(alignment: .bottom){
            gameBody
            HStack{
                deckBody
                Spacer()
                discardBody
            }.padding(.horizontal)
        }
        .padding()
    }
    
    @State private var dealt = Set<Int>()
    
    private func deal(_ card: SetDeckGame.Card) {
        dealt.insert(card.id.hashValue)
    }
    
    private func isUndealt(_ card: SetDeckGame.Card) -> Bool {
        !dealt.contains(card.id.hashValue)
    }
    
    private func dealAnimation(for card: SetDeckGame.Card) -> Animation {
        var delay = 0.0
        if let index = game.undealtCards.firstIndex(where: { $0.id == card.id}){
            delay = Double(index) * (CardConstants.totalDealDuration / Double(game.dealtCards.count))
        }
        return Animation.easeInOut(duration: CardConstants.dealDuration).delay(delay)
    }
    
    private func zIndex(of card: SetDeckGame.Card) -> Double {
        -Double(game.undealtCards.firstIndex(where: { $0.id == card.id }) ?? 0)
    }
    
    var gameBody: some View {
        VStack{
            AspectVGrid(items: game.dealtCards, aspectRatio: 2/3) { card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .padding(4)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .scale))
                    .zIndex(zIndex(of: card))
                    .onTapGesture {
                        withAnimation {
                            game.touch(card)
                        }
                    }
            }
            .padding(.horizontal)
            
//            HStack {
//                Button { game.dealThreeMoreCards()} label: { Text("3 More Cards").font(.title).foregroundColor(.green)}
//                Spacer()
//                Button { game.newGame() } label: { Text("New Game").font(.title).foregroundColor(.black)}
//            }
        }
    }
    
    var deckBody: some View {
        ZStack {
            ForEach(game.undealtCards.filter(isUndealt)) {card in
                CardView(card: card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(AnyTransition.asymmetric(insertion: .opacity, removal: .identity))
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
        .onTapGesture {
                // "deal" cards
            withAnimation {
                game.dealThreeMoreCards()
            }
            for card in game.dealtCards {
                withAnimation(dealAnimation(for: card)) {
                        deal(card)
                    }
                }
        }
    }
        
    var discardBody: some View {
        ZStack {
            ForEach(game.removedCards) { card in
                CardView(card: card)
                    .transition(AnyTransition.asymmetric(insertion: .identity, removal: .opacity))
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .zIndex(zIndex(of: card))
            }
        }
        .frame(width: CardConstants.undealtWidth, height: CardConstants.undealtHeight)
    }
    
    private struct CardConstants {
        static let color =  Color.red
        static let aspectRatio: CGFloat = 2/3
        static let dealDuration: Double = 0.5
        static let totalDealDuration: Double = 2
        static let undealtHeight: CGFloat = 90
        static let undealtWidth = undealtHeight * aspectRatio
    }
}
    
func font(in size: CGSize) -> Font {
    Font.system(size: min(size.width, size.height) * DrawingConstants.fontScale)
}


struct DrawingConstants {
static let cornerRadius: CGFloat = 10
static let lineWidth: CGFloat = 2
static let fontScale: CGFloat = 0.7
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
