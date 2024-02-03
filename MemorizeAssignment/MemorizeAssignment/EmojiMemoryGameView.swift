
import SwiftUI

struct EmojiMemoryGameView: View {
    
    @ObservedObject var viewModel: EmojiMemoryGame

    
    var body: some View {
        VStack {
            Text(viewModel.theme.name).font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
            ScrollView{
                cards
                    .animation(.default, value: viewModel.cards)
            }
            
            HStack {
                Text("Score: \(viewModel.getScore())")
                Spacer()
                Button("New Game") {
                    viewModel.newGame()
                }
            }
        }
        .foregroundColor(.mint)
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)],
                  spacing: 0) {
      
            ForEach(viewModel.cards) { card in
                VStack{
                    CardView(card).aspectRatio(2/3, contentMode: .fit)
                        .padding(4)
                        .onTapGesture {
                            viewModel.chose(card)
                        }
                }
            }
        }
                  .foregroundColor(viewModel.interpretThemeColor())
    }
    
    var emojiSelectorList: some View {
        HStack{
            Spacer()
                selectAnimal
            Spacer()
                selectSea
            Spacer()
                selectHalloween
            Spacer()
        }
        .foregroundColor(.yellow)
        .imageScale(.large)
    }
    
    func emojiSelector(emojiName: String, symbol: String) -> some View {
        VStack {
      }
    }
    
    var selectAnimal: some View {
            emojiSelector(emojiName: "Animal", symbol: "teddybear.fill")
    }
    
    var selectSea: some View {
        emojiSelector(emojiName: "Sea", symbol: "fish.fill")
    }
    
    var selectHalloween: some View {
        emojiSelector(emojiName: "Halloween", symbol: "party.popper.fill")
    }

}

struct CardView: View {
    let card: MemoryGame<String>.Card
  //  let gradient: Gradient
  
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack{
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(lineWidth: 2)
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .aspectRatio(contentMode: .fit)
            }
            .opacity(card.isFaceUp ? 1 : 0)
            base.fill().opacity(card.isFaceUp ? 0 : 1 )
        }
        .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame(themes: themes))
}
