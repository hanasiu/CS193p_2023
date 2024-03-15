//View
import SwiftUI

struct SetGameView: View {
   // typealias Card = SetGame.Card
    @ObservedObject var viewModel: CardSetGame
    
    private let aspectRatio: CGFloat = 3/2
    
    var body: some View {
        VStack {
            cardOrCheatsheet
    
            Spacer(minLength: 0)
            
            HStack {
                Button("Deal 3 More Cards") {
                    viewModel.addSeenCards()
                }.opacity(viewModel.checkSeenCardsIsEqualToSetCards() ? 0 : 1)
                
                Divider().overlay(.black)
                Text("\(viewModel.getScore())")
                Divider().overlay(.black)
                Button("New Game") {
                    viewModel.newGame()
                }
                Divider().overlay(.black)
                Button("cheat") {
                    viewModel.changeCheat()
                }
            }.fixedSize()
            
            
        }
        .padding()
    }
    
    @ViewBuilder
    var cardOrCheatsheet: some View {
        if viewModel.getCheat() {
            ScrollView {
                possibleCorrectCards
            }
        }
        else {
            cards
        }
    }
    
    var cards: some View {
        return AspectVGrid(viewModel.cards.filter { $0.isFaceUp }, aspectRatio: aspectRatio) { card
            in
            CardView(card)
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
            
        }
    }
    
  //  @State private var dealt = Set<Card.id>()
    
    var possibleCorrectCards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 40)], spacing: 30) {
            ForEach(Array(viewModel.possibleCorrectCards.enumerated()), id: \.offset) { index, threeCards in
                VStack{
                    ForEach(threeCards) { card in
                        CardView(card) // Ensure this initializer matches your CardView's expectations
                            .aspectRatio(3/2, contentMode: .fit)
                            .padding(4)
                    }
                }
            }
        }
    }
}


#Preview {
    SetGameView(viewModel: CardSetGame())
}
