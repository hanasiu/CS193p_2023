//View
import SwiftUI

struct SetGameView: View {
    @ObservedObject var viewModel: CardSetGame
    
    private let aspectRatio: CGFloat = 3/2
    var body: some View {
        VStack {
            //            ScrollView {
            cards
            //.opacity(viewModel.checkCardsAllMatched() ? 0 : 1)
            //            }
            ScrollView {
                HStack {
                    Button("Deal 3 More Cards") {
                        viewModel.addSeenCards()
                    }.opacity(viewModel.checkSeenCardsIsEqualToSetCards() ? 0 : 1)
                    Spacer()
                    Text("\(viewModel.getScore())")
                    Spacer()
                    Button("New Game") {
                        viewModel.newGame()
                    }
                }
                Divider()
                possibleCorrectCards
            }
            
        }
        .padding()
    }
    
    var cards: some View {
        return AspectVGrid(viewModel.cards.filter { $0.isSeen }, aspectRatio: aspectRatio) { card
            in
            CardView(card)
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
            
        }
    }
    
    var possibleCorrectCards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 40)], spacing: 90) {
                ForEach(Array(viewModel.possibleCorrectCards.enumerated()), id: \.offset) { index, threeCards in
                    VStack{
                        ForEach(threeCards) { card in
                            CardView(card) // Ensure this initializer matches your CardView's expectations
                                .aspectRatio(2/3, contentMode: .fit)
                                .padding(4)
                    }
                }
            }
        }
        }
//                  .foregroundColor(viewModel.interpretThemeColor())
//        return AspectVGrid(viewModel.model.possibleCorrectCards, aspectRatio: aspectRatio) { card
//            in
//            CardView(card)
//                .padding(4)
//                .onTapGesture {
//                    viewModel.choose(card)
                }
            
        
    



struct CardView: View {
    let card: SetGame<CardExample>.Card
    
    init(_ card: SetGame<CardExample>.Card) {
        self.card = card
    }
    @ViewBuilder
    func getSymbol() -> some View {
        let rectangle = Rectangle().fill(getColor()).border(getBorderColor(), width: card.shading == "open" ? 3.0 : 0.0)
            .opacity(card.shading == "striped" ? 0.3 : 1.0)
            .aspectRatio(1/2, contentMode: .fit)
        
        let oval =  Ellipse()
            .foregroundColor(getColor())
            .overlay(
                Ellipse()
                    .strokeBorder(getBorderColor(), lineWidth: card.shading == "open" ? 3.0 : 0.0)
            ).opacity(card.shading == "striped" ? 0.3 : 1.0)
            .aspectRatio(1/2, contentMode: .fit)
        let diamond = DiamondShape()
            .foregroundColor(getColor())
            .opacity(card.shading == "striped" ? 0.3 : 1.0)
            .overlay(
                DiamondShape()
                    .stroke(getBorderColor(), lineWidth: card.shading == "open" ? 3.0 : 0.0)
            )
            .aspectRatio(1/2, contentMode: .fit)
        
        switch card.number {
        case 1:
            switch card.shape {
            case "oval":
                    oval
            case "rectangle":
                    rectangle
            case "diamond":
                    diamond
            default:
                EmptyView()
            }
        case 2:
            switch card.shape {
            case "oval":
                    oval
                    oval
            case "rectangle":
                    rectangle
                    rectangle
            case "diamond":
                    diamond
                    diamond
            default:
                EmptyView()
            }
        case 3:
            switch card.shape {
            case "oval":
                    oval
                    oval
                    oval
            case "rectangle":
                    rectangle
                    rectangle
                    rectangle
            case "diamond":
                    diamond
                    diamond
                    diamond
            default:
                EmptyView()
            }
        default:
        EmptyView()
        }
    }
    
//    @ViewBuilder
//    func applyShading(to shape: some Shape) -> some View {
//        switch(card.shading) {
//        case "striped":
//            shape.opacity(card.shading == "striped" ? 0.3 : 1.0)
//        default: shape
//        }
//    }

    var body: some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white).strokeBorder(card.chosen ? card.isMatched ? .green : .red : .blue, lineWidth: card.chosen ? card.isMatched ? 10 : 6 : 4)
                HStack{
                    getSymbol()
                }.padding(10)
            }
        }
        
        
    }
    


    
//    func getShape() -> some View {
//        let rectangle = Rectangle().fill(getColor()).border(getBorderColor(), width: card.shading == "open" ? 3.0 : 0.0)
//            .opacity(card.shading == "striped" ? 0.3 : 1.0)
//            .aspectRatio(1/2, contentMode: .fit)
//        let oval =  Ellipse()
//            .foregroundColor(getColor())
//            .overlay(
//                Ellipse()
//                    .strokeBorder(getBorderColor(), lineWidth: card.shading == "open" ? 3.0 : 0.0)
//            ).opacity(card.shading == "striped" ? 0.3 : 1.0)
//            .aspectRatio(1/2, contentMode: .fit)
//        let diamond = DiamondShape()
//            .foregroundColor(getColor())
//            .opacity(card.shading == "striped" ? 0.3 : 1.0)
//            .overlay(
//                DiamondShape()
//                    .stroke(getBorderColor(), lineWidth: card.shading == "open" ? 3.0 : 0.0)
//            )
//            .aspectRatio(1/2, contentMode: .fit)
//        
//        
//        switch card.shape {
//        case "oval":
//            return oval
//        case "rectangle":
//            return rectangle
//        case "diamon":
//            return diamond
//        default: return oval
//        }
//    }
    
    func getColor() -> Color {
        switch card.shading {
        case "solid":
            break;
        case "striped":
            break;
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



struct DiamondShape: Shape {
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: width / 2, y: 0))
        path.addLine(to: CGPoint(x: width, y: height / 2))
        path.addLine(to: CGPoint(x: width / 2, y: height))
        path.addLine(to: CGPoint(x: 0, y: height / 2))
        path.closeSubpath()
        
        return path
    }
}


#Preview {
    SetGameView(viewModel: CardSetGame())
}
