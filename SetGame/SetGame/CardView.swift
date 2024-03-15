//
//  CardView.swift
//  SetGame
//
//  Created by hanasiu on 3/13/24.
//

import SwiftUI

struct CardView: View {
    let card: SetGame<CardExample>.Card
    
    init(_ card: SetGame<CardExample>.Card) {
        self.card = card
    }
   
    var body: some View {
      //  ZStack {
            //let base = RoundedRectangle(cornerRadius: 12)
           // Group {
//                base.fill(.white).strokeBorder(card.chosen ? card.isMatched ? .green : .red : .blue, lineWidth: card.chosen ? card.isMatched ? 10 : 6 : 4)
                symbolBox.cardify(isFaceUp: card.isFaceUp, isMatched: card.isMatched, isChosen: card.isChosen)
        
//                .overlay(cardContents)
            
         //   }
      //  }
    }
    
    var cardContents: some View {
        symbolBox
    }
    
    private var symbolBox: some View {
        HStack {
            ForEach(1...card.number, id: \.self) {_ in
                cardSymbol
            }
        }.padding(10)
        
    }
    
    @ViewBuilder
    private var cardSymbol: some View {
        let squiggle = Squiggle()
            .fill(getColor())
            .overlay(
                Squiggle()
                    .stroke(getBorderColor(), lineWidth: card.shading == "open" || card.shading == "striped" ? 3.0 : 0.0)
            )
            .overlay(Stripe()
                .stroke(getBorderColor(), lineWidth: card.shading == "striped" ? 3.0 : 0.0))
            .clipShape(Squiggle())
            .aspectRatio(1/2, contentMode: .fit)
        
        let oval =  Ellipse()
            .foregroundColor(getColor())
            .overlay(
                Ellipse()
                    .strokeBorder(getBorderColor(), lineWidth: card.shading == "open" || card.shading ==
                                  "striped" ? 3.0 : 0.0)
            )
            .overlay(Stripe()
                .stroke(getBorderColor(), lineWidth: card.shading == "striped" ? 3.0 : 0.0))
            .clipShape(Ellipse())
            .aspectRatio(1/2, contentMode: .fit)
        
        let diamond = Diamond()
            .foregroundColor(getColor())
            .overlay(
                Diamond()
                    .stroke(getBorderColor(), lineWidth: card.shading == "open" || card.shading == "striped" ? 3.0 : 0.0)
            )
            .overlay(Stripe()
                .stroke(getBorderColor(), lineWidth: card.shading == "striped" ? 3.0 : 0.0))
            .clipShape(Diamond())
            .aspectRatio(1/2, contentMode: .fit)

            switch card.shape {
            case "oval":
                oval
            case "rectangle":
                squiggle
            case "diamond":
                diamond
            default:
                EmptyView()
            }
    }
    
    func getColor() -> Color {
        switch card.shading {
        case "solid":
            break;
        case "striped":
            return .white
        case "open":
            return .white
        default:
            return .white
        }
        switch card.color {
        case "yellow":
            return .yellow
        case "green":
            return .green
        case "purple":
            return .purple
        default:
            return .yellow
        }
    }
    
    func getBorderColor() -> Color {
        switch card.color {
        case "yellow":
            return .yellow
        case "green":
            return .green
        case "purple":
            return .purple
        default: return .yellow
        }
    }
}

