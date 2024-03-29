//View-Model

import Foundation
import SwiftUI

class CardSetGame: ObservableObject {
    typealias Card = SetGame.Card
    func generateAllCards() -> [CardExample] {
        var cards:[CardExample] = []
        
        for number in CardNumber.allCases {
            for shape in CardShape.allCases {
                for shading in CardShading.allCases {
                    for color in CardColor.allCases {
                        let card = CardExample(number: number.rawValue,
                                               shape: shape.rawValue,
                                               shading: shading.rawValue,
                                               color: color.rawValue)
                        cards.append(card)
                    }
                }
            }
        }
        return cards
    }
    
    
    private var cardInfos: [CardExample] = []
    
    init() {
        cardInfos = generateAllCards()
        cardInfos.shuffle()
        setGame = createSetGame()
    }
    private func createSetGame() -> SetGame {
        SetGame() { pairIndex in
            if cardInfos.indices.contains(pairIndex) {
                return cardInfos[pairIndex]
            } else {
                return CardExample(number: 1, shape: "diamond", shading: "open", color: "green")
            }
        }
    }
    
    func initializeSeenCards() {
        setGame.initializeSeenCard()
    }
    
    func getSeenCardsNumber() -> Int {
        setGame.getSeenCardsNumber()
    }
    
    private func addCards() -> SetGame {
        SetGame() { pairIndex in
            
            if cardInfos.indices.contains(pairIndex) {
                return cardInfos[pairIndex]
            } else {
                return CardExample(number: 1, shape: "diamond", shading: "open", color: "green")
            }
        }
    }
    @Published private var setGame: SetGame!
    
    var cards: Array<Card> {
        return setGame.cards
    }
    

    var color: Color {
        .blue
    }
    
    func getMatchedWhenAddingCards() -> Bool {
        return setGame.matchedWhenAddingCards
    }
    
    var possibleCorrectCards: Array<Array<Card>> {
        return setGame.possibleCorrectCards
    }
    
    func countCards() -> Int {
        return setGame.cards.count
    }
    
    func checkChosenCardsForAnimation() -> Bool {
        return setGame.checkChosenCardsForAnimation()
    }
//    func falsifyAllMatchedWhenAddingCards() {
//        setGame.falsifyAllMatchedWhenAddingCards()
//    }
    
    func getScore() -> Int {
        return setGame.score
    }
    
    func choose(_ card: Card) {
        setGame.choose(card)
    }
    
    
    func testChoose(_ card: Card) {
        setGame.testChoose(card)
    }
    
    func countChosenCards() -> Int {
        return setGame.countChosenCards()
    }
    
    func addSeenCards() {
        setGame.addSeenCards()
    }
    
    func checkSeenCardsIsEqualToSetCards() -> Bool {
        return setGame.checkSeenCardsIsEqualToSetCards()
    }
    
    func startNewGame() {
        setGame.startNewGame()
//        cardInfos.shuffle()
//        setGame = createSetGame()
        
//        cardInfos = generateAllCards()
//        cardInfos.shuffle()
//        setGame = createSetGame()
    }
    
    func getCheatNotifer() -> Bool {
        return setGame.getCheatNotifer()
    }

    
    func makeChosenAndMatchedFalse(index: Int) {
        setGame.makeChosenAndMatchedFalse(index: index)
    }
    
    func shuffle() {
        setGame.shuffle()
    }
    
    func filterPossibleCorrectCards() {
       setGame.filterPossibleCorrectCards()
    }
    
    func getCheat() -> Bool {
        return setGame.cheat
    }
    
    func changeCheat() {
        setGame.changeCheat()
    }
    
    func getTime() -> Double {
        setGame.getPassedTime()
    }
    
}

struct CardExample: CardProtocol {
    var number: Int
    
    var shape: String
    
    var shading: String 
    
    var color: String
}

enum CardNumber: Int, CaseIterable {
    case one = 1
    case two
    case three
}
enum CardShape: String, CaseIterable {
    case diamond = "diamond"
    case rectangle = "rectangle"
    case oval = "oval"
}
enum CardShading: String, CaseIterable {
    case solid = "solid"
    case striped = "striped"
    case open = "open"
}
enum CardColor: String, CaseIterable {
    case yellow = "yellow"
    case green = "green"
    case purple = "purple"
}
