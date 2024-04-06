//model
import Foundation

struct SetGame{
    private(set) var cards: Array<Card>
    
    private(set) var score = 0
    private(set) var timer = Date()
    private(set) var cheat = false
    
    private var cheatNotifer: Bool {
        possibleCorrectCards.count > 0
    }
    
    func getCheatNotifer() -> Bool {
        return cheatNotifer
    }
    
    private var setCardsNumber = 81
    
    private(set) var matchedWhenAddingCards = false
    
    private var seenCardsNumber = 0 {
        didSet {
            if seenCardsNumber > setCardsNumber {
                seenCardsNumber = setCardsNumber
            }
        }
    }
    
    func getSeenCardsNumber() -> Int {
        seenCardsNumber
    }
    
    mutating func initializeSeenCard() {
        seenCardsNumber = 12
        for index in 0..<seenCardsNumber  {
            cards[index].isFaceUp = true
        }
        filterPossibleCorrectCards()
    }
    
    private var chosenCards: [Card] = []
    private(set) var possibleCorrectCards: [[Card]] = [] {
        didSet {
            //if previous possibleCorrectCards == 0 and current possibleCorrectCards > 0, timer gets started
            if oldValue.count == 0 && possibleCorrectCards.count > 0 {
                timer = Date()
            }
        }
    }
    
    enum ThreeStates: String {
        case allSame = "allSame"
        case allDifferent = "allDifferent"
        case other = "other"
    }
    
    
    private var threeStatesBool: ThreeStates = .other
    
    private func checkAttributes<T: Equatable>(_ attributes: [T]) -> Bool {
        if(attributes.count != 3) { return false }
        
        let allSame = attributes.allSatisfy { $0 == attributes.first }
        let allDifferent = attributes[0] != attributes[1] && attributes[1] != attributes[2] &&
        attributes[0] != attributes[2]
        
        if allSame {
            return true
        } else if allDifferent {
            return true
        } else {
            return false
        }
    }
    private func checkChosenCards() -> Bool {
        guard chosenCards.count == 3 else {
            return false
        }
        
        let numberResults = checkAttributes(chosenCards.map { $0.number })
        let shapeResults = checkAttributes(chosenCards.map { $0.shape })
        let shadingResults = checkAttributes(chosenCards.map { $0.shading })
        let colorResults = checkAttributes(chosenCards.map { $0.color })
        
        return numberResults && shapeResults && shadingResults && colorResults
    }
    
    func checkChosenCardsForAnimation() -> Bool {
        guard chosenCards.count == 3 else {
            return false
        }
        
        let numberResults = checkAttributes(chosenCards.map { $0.number })
        let shapeResults = checkAttributes(chosenCards.map { $0.shape })
        let shadingResults = checkAttributes(chosenCards.map { $0.shading })
        let colorResults = checkAttributes(chosenCards.map { $0.color })
        
        return !(numberResults && shapeResults && shadingResults && colorResults)
    }
    
    private func checkChosenCards(possibleCards: [Card]) -> Bool {
        guard possibleCards.count == 3 else {
            return false
        }
        
        let numberResults = checkAttributes(possibleCards.map { $0.number })
        let shapeResults = checkAttributes(possibleCards.map { $0.shape })
        let shadingResults = checkAttributes(possibleCards.map { $0.shading })
        let colorResults = checkAttributes(possibleCards.map { $0.color })
        
        return numberResults && shapeResults && shadingResults && colorResults
    }
    
    private func combos<T: Hashable>(elements: ArraySlice<T>, k: Int) -> [[T]] {
        if k == 0 {
            return [[]]
        }
        
        guard let first = elements.first else {
            return []
        }
        
        let head = [first]
        let subcombos = combos(elements: elements, k: k - 1)
        var ret = subcombos.map { head + $0 }
        ret += combos(elements: elements.dropFirst(), k: k)
        
        ret = ret.filter { Set($0).count == k }
        
        return ret
    }
    
    private func combos<T: Hashable>(elements: Array<T>, k: Int) -> [[T]] {
        return combos(elements: ArraySlice(elements), k: k)
    }
    
    mutating func filterPossibleCorrectCards() {
        possibleCorrectCards = []
        let visibleCards = cards.filter { $0.isFaceUp && !$0.isMatched }.prefix(30)
        possibleCorrectCards = Array(combos<Card>(elements: visibleCards, k: 3).filter { checkChosenCards(possibleCards: $0) }.prefix(9))
    }
    
    
    
    init(cardInfoFactory: (Int) -> CardProtocol) {
        cards = []
        for index in 0 ..< setCardsNumber {
            let info = cardInfoFactory(index)
            cards.append(Card(id: "\(index+1)", number: info.number,
                              shape: info.shape,
                              shading: info.shading,
                              color: info.color, isChosen: false, isMatched: false, isFaceUp: false
                             ))
        }
        filterPossibleCorrectCards()
        timer = Date()
    }
    
    mutating func startNewGame() {
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isChosen = false
            cards[index].isMatched = false
        }
        cards.shuffle()
        filterPossibleCorrectCards()
        seenCardsNumber = 0
        score = 0
        timer = Date()
        cheat = false
    }
    
    mutating func shuffle() {
        let faceUpCardIndices = cards.indices.filter { cards[$0].isFaceUp && !cards[$0].isMatched }
        let faceUpCardsToShuffle = faceUpCardIndices.map { cards[$0] }.shuffled()
        
        for (index, cardIndex) in faceUpCardIndices.enumerated() {
            cards[cardIndex] = faceUpCardsToShuffle[index]
        }
    }
    
    mutating func changeCheat() {
        cheat = !cheat
    }
    
    mutating func makeFaceUp() {
        
    }
    
    mutating func makeChosenAndMatchedFalse(index: Int) {
        cards[index].isMatched = false
        cards[index].isChosen = false
    }
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {
            $0.id == card.id
        }) {
            if(checkChosenCards()) {
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[0].id })
                {
                    cards[i].isChosen = false
                }
                
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[1].id })
                {
                    cards[i].isChosen = false
                }
                
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[2].id })
                {
                    cards[i].isChosen = false
                }
                chosenCards.removeAll()
                filterPossibleCorrectCards()
            } else if(chosenCards.count == 3) {
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[0].id })
                {
                    cards[i].isChosen = false
                }
                
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[1].id })
                {
                    cards[i].isChosen = false
                }
                
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[2].id })
                {
                    cards[i].isChosen = false
                }
                chosenCards.removeAll()
                filterPossibleCorrectCards()
            }
            
            if(cards[chosenIndex].isChosen) {
                cards[chosenIndex].isChosen = !cards[chosenIndex].isChosen
                chosenCards.removeAll( where: { $0.id == cards[chosenIndex].id } )
                cards[chosenIndex].isChosen = false
            } else if(chosenCards.count < 3) {
                cards[chosenIndex].isChosen = true
                chosenCards.append(cards[chosenIndex])
            }
            
            if (checkChosenCards()) {
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[0].id })
                {
                    cards[i].isMatched = true
                }
                
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[1].id })
                {
                    cards[i].isMatched = true
                }
                
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[2].id })
                {
                    cards[i].isMatched = true
                }
                score = (200-10*Int(timer.distance(to: Date()).rounded(.down))) > 100 ? score + 200 - 10*Int(timer.distance(to: Date()).rounded(.down)) : (score + 100)
                if(cards.allSatisfy { $0.isMatched })
                {
                    //                    if let i = cards.firstIndex(where: { $0.id ==  chosenCards[0].id })
                    //                    {
                    //                        cards[i].isFaceUp = false
                    //                    }
                    //
                    //                    if let i = cards.firstIndex(where: { $0.id ==  chosenCards[1].id })
                    //                    {
                    //                        cards[i].isFaceUp = false
                    //                    }
                    //
                    //                    if let i = cards.firstIndex(where: { $0.id ==  chosenCards[2].id })
                    //                    {
                    //                        cards[i].isFaceUp = false
                    //                    }
                    
                }
                // filterPossibleCorrectCards()
            }
        }
        filterPossibleCorrectCards()
    }
    
    mutating func testChoose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: {
            $0.id == card.id
        }) {
            if(chosenCards.count == 3)
            {
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[0].id })
                {
                    cards[i].isFaceUp = false
                }
                
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[1].id })
                {
                    cards[i].isFaceUp = false
                }
                
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[2].id })
                {
                    cards[i].isFaceUp = false
                }
                chosenCards.removeAll()
                seenCardsNumber += 3
                if(seenCardsNumber <= setCardsNumber) {
                    for index in seenCardsNumber-3 ..< seenCardsNumber {
                        cards[index].isFaceUp = true
                    }
                }
            }
            
            if(cards[chosenIndex].isChosen) {
                cards[chosenIndex].isChosen = !cards[chosenIndex].isChosen
                chosenCards.removeAll( where: { $0.id == cards[chosenIndex].id } )
                cards[chosenIndex].isChosen = false
            } else if(chosenCards.count < 3) {
                cards[chosenIndex].isChosen = true
                chosenCards.append(cards[chosenIndex])
            }
            
            if(chosenCards.count == 3)
            {
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[0].id })
                {
                    cards[i].isMatched = true
                }
                
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[1].id })
                {
                    cards[i].isMatched = true
                }
                
                if let i = cards.firstIndex(where: { $0.id ==  chosenCards[2].id })
                {
                    cards[i].isMatched = true
                }
                if(cards.allSatisfy { $0.isMatched })
                {
                    if let i = cards.firstIndex(where: { $0.id ==  chosenCards[0].id })
                    {
                        cards[i].isFaceUp = false
                    }
                    
                    if let i = cards.firstIndex(where: { $0.id ==  chosenCards[1].id })
                    {
                        cards[i].isFaceUp = false
                    }
                    
                    if let i = cards.firstIndex(where: { $0.id ==  chosenCards[2].id })
                    {
                        cards[i].isFaceUp = false
                    }
                }
            }
        }
        
    }
    
    func countChosenCards() -> Int {
        return chosenCards.count
    }
    
    func getPassedTime() -> Double {
        timer.distance(to: Date()).rounded(.down)
    }
    
    //    mutating func addSeenCards() {
    //        seenCardsNumber += 3
    //        if(seenCardsNumber <= setCardsNumber) {
    //            for index in seenCardsNumber-3 ..< seenCardsNumber {
    //                cards[index].isFaceUp = true
    //            }
    //        }
    //    }
    mutating func addSeenCards() {
        filterPossibleCorrectCards()
        if  possibleCorrectCards.count > 0 {
            score -= 50
        }
        
        if(checkChosenCards()) {
            if let i = cards.firstIndex(where: { $0.id ==  chosenCards[0].id })
            {
                cards[i].isChosen = false
            }
            
            if let i = cards.firstIndex(where: { $0.id ==  chosenCards[1].id })
            {
                cards[i].isChosen = false
            }
            
            if let i = cards.firstIndex(where: { $0.id ==  chosenCards[2].id })
            {
                cards[i].isChosen = false
            }
            matchedWhenAddingCards = true
            
            chosenCards.removeAll()
        } else {
            matchedWhenAddingCards = false
        }
        seenCardsNumber += 3
        if(seenCardsNumber <= setCardsNumber) {
            for index in seenCardsNumber-3 ..< seenCardsNumber {
                cards[index].isFaceUp = true
            }
        }
        filterPossibleCorrectCards()
    }
    
    func checkSeenCardsIsEqualToSetCards() -> Bool {
        return seenCardsNumber == setCardsNumber
    }
    
    func checkChoosenCardsMatched() -> Bool {
        if(chosenCards.count == 3) {
            if (((chosenCards[0].number == chosenCards[1].number &&
                  chosenCards[1].number == chosenCards[2].number) ||
                 (chosenCards[0].number != chosenCards[1].number && chosenCards[1].number != chosenCards[2].number && chosenCards[0].number != chosenCards[2].number))
                &&
                ((chosenCards[0].shape == chosenCards[1].shape &&
                  chosenCards[1].shape == chosenCards[2].shape) ||
                 (chosenCards[0].shape != chosenCards[1].shape && chosenCards[1].shape != chosenCards[2].shape && chosenCards[0].shape != chosenCards[2].shape))
                &&
                ((chosenCards[0].shading == chosenCards[1].shading &&
                  chosenCards[1].shading == chosenCards[2].shading) ||
                 (chosenCards[0].shading != chosenCards[1].shading && chosenCards[1].shading != chosenCards[2].shading && chosenCards[0].shading != chosenCards[2].shading))
                &&
                ((chosenCards[0].color == chosenCards[1].color &&
                  chosenCards[1].color == chosenCards[2].color) ||
                 (chosenCards[0].color != chosenCards[1].color && chosenCards[1].color != chosenCards[2].color && chosenCards[0].color != chosenCards[2].color))
            ) {
                return true
            }
        } else {
            return false
        }
        return false
    }
    
    struct Card: Identifiable, Equatable, Hashable, IsMatchedAndChosen {
        var id: String
        
        var number: Int
        var shape: String
        var shading: String
        var color: String
        
        var isChosen: Bool
        
        var isMatched: Bool
        
        var isFaceUp: Bool
    }
}

protocol CardProtocol {
    var number: Int { get }
    var shape: String { get }
    var shading: String { get }
    var color: String { get }
}
