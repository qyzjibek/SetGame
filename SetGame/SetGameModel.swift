//
//  SetGameModel.swift
//  SetGame
//
//  Created by Zhibek Rahymbekkyzy on 18.01.2022.
//

import Foundation

struct SetGame {
    
    private(set) var deckCards: Array<Card>
    
    private var selectedCards: [Card] { deckCards.filter{ $0.isTouched && $0.isDealt }}
    var dealtCards: [Card] { deckCards.filter{ $0.isDealt && !$0.isMatched}}
    var undealtCards: [Card] { deckCards.filter{ !$0.isMatched && !$0.isDealt}}
    var removedCards: [Card] { deckCards.filter { $0.isMatched }}
    
    var state: State = .selectCard
    var randomIndexes = Array<Card>()
    
    init(){
        deckCards = []
        for number in Card.number.allCases {
            for color in Card.color.allCases {
                for shape in Card.shape.allCases {
                    for shading in Card.shading.allCases {
                        deckCards.append(Card(CardNumber: number, CardColor: color, CardShape: shape, CardShading: shading))
                    }
                }
            }
        }
        
        deckCards.shuffle()
        dealCards(count: 12)
    }
    
    mutating func touch(card: Card) -> Void {
        if let chosenIndex = deckCards.firstIndex(where: { $0.id == card.id}){
            if deckCards[chosenIndex].isTouched {
                deckCards[chosenIndex].isTouched = false
                return
            }
            
            deckCards[chosenIndex].isTouched = true
            
            if selectedCards.count == 3 {
                isCompleteSet()
            }
        }
    }
    
    enum State {
        case match
        case misMatch
        case tooFewCards
        case selectCard
        case gameOver
    }
    
    private mutating func dealCards(count: Int) {
        var cardsDealt = 0
        if undealtCards.count == 0 {
            state = .gameOver
            return
        }
        
        
        for card in undealtCards {
            if let selectedIndex: Int = deckCards.firstIndex(where: {$0.id == card.id}) {
                        deckCards[selectedIndex].isDealt = true
                        cardsDealt += 1
                    }
            
                    if (cardsDealt >= count) {
                        print(undealtCards.count)
                        break
                    }
                }
    }
    
    mutating private func isCompleteSet() -> Void {
        state = .selectCard
        if MatchingTest() == .match {
            state = .match
            matchingCards()
            return
        }
        state = .misMatch
        for card in selectedCards {
            if let indexOfMatchedCard = deckCards.firstIndex(where: { $0.id == card.id
            }){
                deckCards[indexOfMatchedCard].isTouched = false
            }
        }
    }
    
    mutating func MatchingTest() -> State {
        var colors: [Int] = []
        var shapes: [Int] = []
        var fills: [Int] = []
        var numbersOfShapes: [Int] = []
        
        func checkColor(color: Card.color) -> Int {
            switch color{
            case .red: return 1
            case .green: return 2
            case .purple: return 3
            }
        }
        
        func checkNumber(number: Card.number) -> Int {
            switch number{
            case .one: return 1
            case .two: return 2
            case .three: return 3
            }
        }
        
        func checkShape(shape: Card.shape) -> Int {
            switch shape{
            case .oval: return 1
            case .rectangle: return 2
            case .squiggle: return 3
            }
        }
        
        func checkShading(shading: Card.shading) -> Int {
            switch shading {
            case .open: return 1
            case .half: return 2
            case .full: return 3
            }
        }
        
        for card in selectedCards {
            colors.append(checkColor(color: card.CardColor))
            shapes.append(checkShape(shape: card.CardShape))
            fills.append(checkShading(shading: card.CardShading))
            numbersOfShapes.append(checkNumber(number: card.CardNumber))
       }

        func checkMatch(_ elements: [AnyHashable]) -> Bool {
                    return Array(Set(elements)).count != 2
        }
        
        return checkMatch(colors) &&
            checkMatch(shapes) &&
            checkMatch(fills) &&
        checkMatch(numbersOfShapes) ? .match : .misMatch
        
    }
    
    private mutating func matchingCards() -> Void {
        state = .selectCard
        for card in selectedCards {
            if let indexOfMatchedCard = deckCards.firstIndex(where: { $0.id == card.id
            }){
                deckCards[indexOfMatchedCard].isMatched = true
                deckCards[indexOfMatchedCard].isDealt = false
                deckCards[indexOfMatchedCard].isTouched = false
            }
        }
        
        while dealtCards.count < 12 {
            dealCards(count: 3)
        }
        
        print(undealtCards.count)
    }
    
    mutating func dealThreeMoreCards() -> Void {
        if !undealtCards.isEmpty {
            dealCards(count: 3)
        }
    }

    
    struct Card: Identifiable, Equatable {
        var id = UUID()
        var isTouched: Bool = false
        var isMatched: Bool = false
        var isDealt: Bool = false
        
        var CardNumber: number
        var CardColor: color
        var CardShape: shape
        var CardShading: shading
        
        enum number: CaseIterable {case one, two, three}
        enum color: CaseIterable {case red, purple, green}
        enum shape: CaseIterable {case rectangle, oval, squiggle}
        enum shading: CaseIterable {case full, half, open}
    }
}

