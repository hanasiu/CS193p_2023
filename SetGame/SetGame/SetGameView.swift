//View
import SwiftUI

struct SetGameView: View {
    typealias Card = SetGame.Card
    @ObservedObject var setGameViewer: CardSetGame
    
    private let aspectRatio: CGFloat = 3/2
    private let spacing: CGFloat = 4
    private let dealAnimation: Animation = .easeInOut(duration: 1.5)
    private let initialDealAnimation: Animation = .easeInOut(duration: 2)
    private let dealtInterval: TimeInterval = 0.15
    private let intervalBetweenDiscardAndDistribute: TimeInterval = 1
    private let deckWidth: CGFloat = 50
    private let cornerRadius: CGFloat = 12
    private let duration: CGFloat = 1
    var body: some View {
        VStack {
            discardPile
            cardOrCheatsheet
            HStack {
                VStack {
                    cheat
                    shuffle
                }
                Spacer()
                VStack {
                    deck.foregroundColor(setGameViewer.color)
                    score
                    //cardAdder
                }
                Spacer()
                newGame
                //Text("\(setGameViewer.getTime())")
            }
            .font(.largeTitle)
            notify
        }
        .padding()
    }
    
    private var notify: some View {
        if(setGameViewer.getCheatNotifer()) {
            Text("Feed More, get penalty")
                .foregroundColor(.red)
                .font(.largeTitle)
        } else {
            Text("Need more cards.").foregroundColor(.blue)
                .font(.largeTitle)
        }
    }
    
    private var cheat: some View {
        Button("cheat") {
            setGameViewer.filterPossibleCorrectCards()
            setGameViewer.changeCheat()
        }
    }
    
    private var score: some View {
        Text("\(setGameViewer.getScore())")
            .animation(nil)
    }
    
    private var cardAdder: some View {
        Button("Deal 3 More Cards") {
            setGameViewer.addSeenCards()
        }.opacity(setGameViewer.checkSeenCardsIsEqualToSetCards() ? 0 : 1)
    }
    
    private var newGame: some View {
        //        var delay: TimeInterval = 0
        //        for index in 0..<setGameViewer.getSeenCardsNumber() {
        //        withAnimation(dealAnimation.delay(delay)) {
        //            _ = dealt.insert(setGameViewer.cards[index].id)
        //            }
        //            delay += dealtInterval
        //        }
        Button("New Game") {
//            withAnimation(.interactiveSpring(response: 1, dampingFraction: 0.5)) {
                // setGameViewer.shuffle()
            withAnimation(.interactiveSpring(response: 1, dampingFraction: 0.5)) {
                    getBackCards()
                    setGameViewer.startNewGame()
                    if setGameViewer.getCheat() {
                        setGameViewer.changeCheat()
                    }
                }
                distributeCards()
//                withAnimation(initialDealAnimation.delay(1)) {
//                    setGameViewer.initializeSeenCards()
//                }
//                initialDeal2()
//                                setGameViewer.initializeSeenCards()
//                                initialDeal()
            //}
        }
    }
    
    @ViewBuilder
    var cardOrCheatsheet: some View {
        if setGameViewer.getCheat() {
            ScrollView {
                possibleCorrectCards
            }
        }
        else {
            cards
        }
    }
    
    @Namespace private var mainGameNamespace
    
    var cards: some View {
        return AspectVGrid(setGameViewer.cards.filter { $0.isFaceUp }, aspectRatio: aspectRatio) { card
            in
            if isDealt(card) {
                CardView(card, setGameViewer.checkChosenCardsForAnimation())
                    .padding(spacing)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                //.overlay(FlyingNumber(number: scoreChange(causedBy: card)))
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 2)) {
                            setGameViewer.choose(card)
                            makeDiscard()
                            //                            if(card.isMatched && !card.isChosen) {
                            //                                matched.insert(card.id)
                            
                            //                            }
                        }
                    }
                
            }
        }
    }
    
    private var shuffle: some View {
        Button("shuffle") {
            withAnimation(.interactiveSpring(response: 1, dampingFraction: 0.5)) {
                setGameViewer.shuffle()
            }
        }
    }
    
    //Identifiable's associatedtype: ID
    @State private var dealt = Set<Card.ID>()
    
    //@State private var stateDelay: TimeInterval = 0
    
    private func isDealt(_ card: Card) -> Bool {
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        setGameViewer.cards.filter {!isDealt($0) && !isDiscarded($0)}
    }
    
    @Namespace private var dealingNamespace
    
    
    private var deck: some View {
        var cardOffset: CGFloat = 0
        return ZStack {
            ForEach(undealtCards) { card in
                cardOffset += 0.05
                return CardView(card, setGameViewer.checkChosenCardsForAnimation())
                //                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                
                //                    .matchedGeometryEffect(id: card.id, in: discardNamespace) // check
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    .offset(x: cardOffset, y:cardOffset)
//                    .transition(.asymmetric(insertion: .identity, removal: .identity))
      
                //                    .overlay{
                //                        RoundedRectangle(cornerRadius: cornerRadius)
                //                    }
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .shadow(color: .black, radius: 1, x: 2, y: 2)
        .onTapGesture {
//            if setGameViewer.getSeenCardsNumber() > 0 {
//                
//                //   makeDiscard()
//         
//                    setGameViewer.addSeenCards()
//
//                    dealThreeMoreCards()
//
//                //   discardAndThenDistribute()
//            } else if setGameViewer.getSeenCardsNumber() == 0 {
//                setGameViewer.initializeSeenCards()
//                initialDeal()
//            }
            distributeCards()
        }

    }
    
    //    private var deck: some View {
    //        ZStack {
    //            ForEach(undealtCards) { card in
    //                CardView(card)
    //                    .matchedGeometryEffect(id: card.id, in: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Namespace@*/Namespace().wrappedValue/*@END_MENU_TOKEN@*/)
    //        }
    //    }
    
    private func distributeCards() {
            if setGameViewer.getSeenCardsNumber() > 0 {
                withAnimation(dealAnimation) {
                    setGameViewer.addSeenCards()
                }
                dealThreeMoreCards()
            } else if setGameViewer.getSeenCardsNumber() == 0 {
                withAnimation(initialDealAnimation) {
                    setGameViewer.initializeSeenCards()
                }
                initialDeal()
        }
    }
    
    private func initialDeal2() {
        var delay: TimeInterval = 3
        //        for card in setGameViewer.cards {
        //        withAnimation(dealAnimation.delay(delay)) {
        //                _ = dealt.insert(card.id)
        //            }
        //            delay += dealtInterval
        //        }
        //
        for index in 0..<setGameViewer.getSeenCardsNumber() {
            withAnimation(initialDealAnimation.delay(delay)) {
                _ = dealt.insert(setGameViewer.cards[index].id)
            }
            delay += dealtInterval
        }
    }
    
    private func initialDeal() {
        var delay: TimeInterval = 0
        //        for card in setGameViewer.cards {
        //        withAnimation(dealAnimation.delay(delay)) {
        //                _ = dealt.insert(card.id)
        //            }
        //            delay += dealtInterval
        //        }
        //
        for index in 0..<setGameViewer.getSeenCardsNumber() {
            withAnimation(initialDealAnimation.delay(delay)) {
                _ = dealt.insert(setGameViewer.cards[index].id)
            }
            delay += dealtInterval
        }
    }
    
    private func getBackCards() {
        //   var delay: TimeInterval = 0.5
        
        //for index in 0..<setGameViewer.getSeenCardsNumber() {
        //        withAnimation(dealAnimation.delay(delay)) {
        //            _ = dealt.remove(setGameViewer.cards[index].id)
        //            }
        //            delay += dealtInterval
        //        }
        withAnimation(dealAnimation) {
            // setGameViewer.shuffle()
            dealt.removeAll()
            discarded.removeAll()
        }
        // }
    }
    
    private func dealThreeMoreCards() {
        var delay: TimeInterval = 0
        withAnimation(dealAnimation.delay(delay)) {
//            delay += intervalBetweenDiscardAndDistribute
        //discard
        for index in 0..<setGameViewer.getSeenCardsNumber() {
            if(setGameViewer.cards[index].isMatched) {
                    dealt.remove(setGameViewer.cards[index].id)
                    _ = discarded.insert(setGameViewer.cards[index].id)
                }
            }
        }
        if(setGameViewer.getMatchedWhenAddingCards()) {
            delay += intervalBetweenDiscardAndDistribute
        }
        //deal
        for index in setGameViewer.getSeenCardsNumber()-3..<setGameViewer.getSeenCardsNumber() {
        withAnimation(dealAnimation.delay(delay)) {
            _ = dealt.insert(setGameViewer.cards[index].id)
        }
        delay += dealtInterval
    }
}
    
    
//    @State private var dealt = Set<Card.ID>()
//    
//    private func isDealt(_ card: Card) -> Bool {
//        dealt.contains(card.id)
//    }
//    
//    private var undealtCards: [Card] {
//        setGameViewer.cards.filter {!isDealt($0)}
//    }
//
    
    @State private var discarded = Set<Card.ID>()
    
    private func isDiscarded(_ card: Card) -> Bool {
        discarded.contains(card.id)
    }
    
    private var discardedCards: [Card] {
        setGameViewer.cards.filter {
            isDiscarded($0)
        }
    }
    
    @Namespace private var discardNamespace
    
    private func makeDiscard() {

//        for index in 0..<setGameViewer.getSeenCardsNumber() {
//        withAnimation(dealAnimation) {
//            _ = matched.insert(setGameViewer.cards[index].id)
//            }
        var delay: TimeInterval = 0
   
            for index in 0..<setGameViewer.getSeenCardsNumber() {
                if(setGameViewer.cards[index].isMatched && !setGameViewer.cards[index].isChosen) {
                    //setGameViewer.cards[index].isChosen
                    // withAnimation(dealAnimation.delay(delay)) {
                    withAnimation(dealAnimation.delay(delay)) {
                        dealt.remove(setGameViewer.cards[index].id)
                        _ = discarded.insert(setGameViewer.cards[index].id)
                    }
                    //                }
                                    delay += dealtInterval
                    
                }
            }
        
        
        
//        withAnimation(dealAnimation.delay(delay)) {
//
//            _ = matched.insert(setGameViewer.cards[index].id)
//            }
//            delay += dealtInterval
//        }
            
    }
    
//    private func discardAndThenDistribute() {
//
////        withAnimation(dealAnimation.delay(1)) {
////            makeDiscard()
////        }
////        dealThreeMoreCards()
//        
//        var delay: TimeInterval = 1
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//                withAnimation(self.dealAnimation.delay(delay)) {
//                    makeDiscard()
//                }
//            }
//        delay += 1
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//                withAnimation(self.dealAnimation.delay(delay)) {
//                    makeDiscard()
//                }
//            }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
//                withAnimation(self.dealAnimation.delay(delay)) {
//                    dealThreeMoreCards()
//                }
//            }
// 
//    }
    
    private var discardPile: some View {
        var cardOffset: CGFloat = 0
        return ZStack {
            ForEach(discardedCards) { card in
                cardOffset += 0.05
                return CardView(card, setGameViewer.checkChosenCardsForAnimation())
                    .matchedGeometryEffect(id: card.id, in: discardNamespace)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
//                    .matchedGeometryEffect(id: card.id, in: mainGameNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .offset(x: cardOffset, y:cardOffset)
//                    .overlay{
//                        RoundedRectangle(cornerRadius: cornerRadius)
//                    }
            }
        }
        .frame(width: deckWidth, height: deckWidth / aspectRatio)
        .shadow(color: .black, radius: 1, x: 2, y: 2)
    }
    
  
    
    var possibleCorrectCards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: Constants.screenWidth), spacing: 80)], spacing: 30) {
                ForEach(Array(setGameViewer.possibleCorrectCards.enumerated()), id: \.offset) { index, threeCards in
                    ZStack {
                        let base = RoundedRectangle(cornerRadius: cornerRadius)
                        base
                            .strokeBorder(.blue, lineWidth: 4)
                            .background(base.fill(.white))
                        VStack{
                            ForEach(threeCards) { card in
                                CardView(card, setGameViewer.checkChosenCardsForAnimation()) // Ensure this initializer matches your CardView's expectations
                                    .aspectRatio(3/2, contentMode: .fit)
                                    .padding(4)
                            }
                        }
                    }
                }
            }
        
    }
    
    private struct Constants {
        static let screenWidth: CGFloat = UIScreen.screenWidth/4
        static let aspectRatio: CGFloat = 3/2
        static let lineWidth: CGFloat = screenWidth * aspectRatio
    }
    
    
}

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}

#Preview {
    SetGameView(setGameViewer: CardSetGame())
}
