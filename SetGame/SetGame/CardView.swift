//
//  CardView.swift
//  SetGame
//
//  Created by hanasiu on 3/13/24.
//

import SwiftUI

struct CardView: View {
    let card: SetGame.Card
    let isVibrate: Bool
    private let vibrate: Animation = .linear(duration: 0.1).repeatForever()
    
    init(_ card: SetGame.Card, _ isVibrate: Bool) {
        self.card = card
        self.isVibrate = isVibrate
    }
   
    var body: some View {
      //  ZStack {
            //let base = RoundedRectangle(cornerRadius: 12)
           // Group {
//                base.fill(.white).strokeBorder(card.chosen ? card.isMatched ? .green : .red : .blue, lineWidth: card.chosen ? card.isMatched ? 10 : 6 : 4)
              cardContents
            .cardify(isFaceUp: card.isFaceUp, isMatched:
                            card.isMatched, isChosen: card.isChosen)
        //    .animation(.linear(duration: 2), value: card.isFaceUp)
            .transition(.scale)
        

          //  .transition(.asymmetric(insertion: .identity, removal: .identity))

        
//                .overlay(cardContents)
            
         //   }
      //  }
    }
    
    var cardContents: some View {
        symbolBox
            .offset(x: isVibrate && card.isChosen ? -15 : 0)
            .animation(isVibrate ? vibrate : Animation.default, value: isVibrate)
            .rotationEffect(.degrees(card.isMatched ? 720 : 0))
//            .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: card.isMatched)
//            .rotationEffect(.degrees(!card.isMatched && card.isChosen ? 10 : 0))
        
            //.rotationEffect(.degrees(!card.isMatched ? 180 : 0))
//
            
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
                    .stroke(getBorderColor(), lineWidth: card.shading == "open" || card.shading == "striped" ? 4.0 : 0.0)
            )
            .overlay(Stripe()
                .stroke(getBorderColor(), lineWidth: card.shading == "striped" ? 4.0 : 0.0))
            .clipShape(Squiggle())
            .aspectRatio(1/2, contentMode: .fit)
        
        let oval =  Ellipse()
            .foregroundColor(getColor())
            .overlay(
                Ellipse()
                    .strokeBorder(getBorderColor(), lineWidth: card.shading == "open" || card.shading ==
                                  "striped" ? 4.0 : 0.0)
            )
            .overlay(Stripe()
                .stroke(getBorderColor(), lineWidth: card.shading == "striped" ? 4.0 : 0.0))
            .clipShape(Ellipse())
            .aspectRatio(1/2, contentMode: .fit)
        
        let diamond = Diamond()
            .foregroundColor(getColor())
            .overlay(
                Diamond()
                    .stroke(getBorderColor(), lineWidth: card.shading == "open" || card.shading == "striped" ? 4.0 : 0.0)
            )
            .overlay(Stripe()
                .stroke(getBorderColor(), lineWidth: card.shading == "striped" ? 4.0 : 0.0))
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

extension Animation {
    static func spin(duration: TimeInterval) -> Animation {
        .linear(duration: duration).repeatForever(autoreverses: false)
    }
}
