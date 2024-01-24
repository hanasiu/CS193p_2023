//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by kimyu on 1/6/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            ScrollView {
                cards
                    .animation(.default, value: viewModel.cards)
                
            }
            Button("Schuffle") {
                viewModel.shuffle()
            }
        }
        .foregroundColor(.mint )
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 85), spacing: 0)],
                  spacing: 0) {
            ForEach(viewModel.cards) { card in
                VStack {
                    CardView(card)
                        .aspectRatio(2/3, contentMode: .fit)
                        .padding(4)
                        .onTapGesture {
                            viewModel.choose(card)
                        }
                }
            }
        }
        .foregroundColor(.blue)
    }
}

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    init(_ card: MemoryGame<String>.Card) {
        self.card = card
    }
    
    var body: some View {
            ZStack
          {
              let base =  RoundedRectangle(cornerRadius: 12)
              Group {
                    base.fill(.white)
                    base.strokeBorder(lineWidth: 2)
                  Text(card.content)
                      .font(.system(size: 200))
                      .minimumScaleFactor(0.01)
                      .aspectRatio(contentMode: .fit)
    
              }
              .opacity(card.isFaceUp ? 1 : 0)
              base.fill().opacity(card.isFaceUp ? 0 : 1)
          }
          .opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
    }
}

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
