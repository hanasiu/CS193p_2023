
import Foundation



struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        //numbeOfPairsOfCards < 2 -> 2
        for pairIndex in 0..<max(2,numberOfPairsOfCards) {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex+1)a"))
            cards.append(Card(content: content, id: "\(pairIndex+1)b"))
        }
    }
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter {index in cards[index].isFaceUp}.only }
        set { cards.indices.forEach{ cards[$0].isFaceUp = ( newValue == $0)}}
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {
            $0.id == card.id
        }) {
            if !cards[chosenIndex].isFaceUp &&
                !cards[chosenIndex].isMatched {
                if let potentialMatchedIndex =
                    indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content ==
                        cards[potentialMatchedIndex].content {
                        cards[potentialMatchedIndex].isMatched = true
                        cards[chosenIndex].isMatched = true
                        //match -> get 2 score
                        score += 2
                    }
                    else {
                        //already seen ? then score -1
                        cards[chosenIndex].seen ? (score = score - 1) : (cards[chosenIndex].seen = true)
                        cards[potentialMatchedIndex].seen ? (score = score - 1) : (cards[potentialMatchedIndex].seen = true)
                    }
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
            }
            
        }
    }
    
    mutating func shuffle() {
        cards.shuffle()
        //   print(cards)
    }
    
    func getScore() -> Int {
        return score
    }
    var score = 0
    
    struct Card: Identifiable, Equatable, CustomDebugStringConvertible {
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        var seen = false
        
        var id: String
        
        var debugDescription: String {
            return "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched" : "")"
        }
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}

