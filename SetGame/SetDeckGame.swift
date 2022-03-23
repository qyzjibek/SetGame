//
//  SetDeckGame.swift
//  SetGame
//
//  Created by Zhibek Rahymbekkyzy on 19.01.2022.
//

import SwiftUI

class SetDeckGame: ObservableObject {
    typealias Card = SetGame.Card
    
    @Published var model = SetGame()
    
    var state: SetGame.State {
        model.state
    }
    
    var dealtCards: [Card] {
        model.dealtCards
    }
    
    var undealtCards: [Card] {
        model.undealtCards
    }
    
    var removedCards: [Card] {
        model.removedCards
    }
    
    func matchingTest() -> SetGame.State {
        model.MatchingTest()
    }
    
// MARK: - Intent
    
    func touch(_ card: Card) -> Void{
        model.touch(card: card)
    }
    
    func dealThreeMoreCards() -> Void {
        model.dealThreeMoreCards()
    }
    
    func newGame() {
        model = SetGame()
    }
}
