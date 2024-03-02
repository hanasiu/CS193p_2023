//View-Model

import Foundation

class CardSetGame: ObservableObject {
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
        model = createSetGame()
    }
    private func createSetGame() -> SetGame<CardExample> {
        SetGame() { pairIndex in
            
            if cardInfos.indices.contains(pairIndex) {
                return cardInfos[pairIndex]
            } else {
                return CardExample(number: 1, shape: "diamond", shading: "open", color: "green")
            }
        }
    }
    
    private func addCards() -> SetGame<CardExample> {
        SetGame() { pairIndex in
            
            if cardInfos.indices.contains(pairIndex) {
                return cardInfos[pairIndex]
            } else {
                return CardExample(number: 1, shape: "diamond", shading: "open", color: "green")
            }
        }
    }
    @Published private var model: SetGame<CardExample>!
    
    var cards: Array<SetGame<CardExample>.Card> {
        return model.cards
    }
    
    var possibleCorrectCards: Array<Array<SetGame<CardExample>.Card>> {
        return model.possibleCorrectCards
    }
    
    func countCards() -> Int {
        return model.countCards()
    }
    
    func getScore() -> Int {
        return model.getScore()
    }
    
    func choose(_ card: SetGame<CardExample>.Card) {
        model.choose(card)
    }
    
    
    func testChoose(_ card: SetGame<CardExample>.Card) {
        model.testChoose(card)
    }
    
    func countChosenCards() -> Int {
        return model.countChosenCards()
    }
    
    func addSeenCards() {
        model.addSeenCards()
    }
    
    func checkSeenCardsIsEqualToSetCards() -> Bool {
        return model.checkSeenCardsIsEqualToSetCards()
    }
    
    func newGame() {
        cardInfos.shuffle()
        model = createSetGame()
    }
    
    func filterPossibleCorrectCards() -> Any {
       return model.filterPossibleCorrectCards()
    }
    
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
