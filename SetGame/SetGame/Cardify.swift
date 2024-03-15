import SwiftUI


//base.fill(.white).strokeBorder(card.chosen ? card.isMatched ? .green : .red : .blue, lineWidth: card.chosen ? card.isMatched ? 10 : 6 : 4)
struct Cardify: ViewModifier, Animatable {
    init(isFaceUp: Bool, isMatched: Bool, isChosen: Bool) {
        rotation = isFaceUp ? 0 : 180
        self.isMatched = isMatched
        self.isChosen = isChosen
    }
    var isFaceUp: Bool {
        rotation < 90
    }
    
    var isMatched: Bool
    
    var isChosen: Bool
    
    var rotation: Double
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    func body(content: Content) -> some View {
        ZStack {
            let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            base
            
               // .strokeBorder(.red)
                //.strokeBorder(lineWidth: Constants.lineWidth)
                .strokeBorder(isChosen ? isMatched ? .green : .red : .blue, lineWidth: isChosen ? isMatched ? 8 : 6 : 4)
                .shadow(color: .red, radius:0.1)
                .background(base.fill(.white))
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
           
            
        }
        .rotation3DEffect(
            .degrees(rotation),
            axis: (x: 1.0, y: 0.0, z: 0.0)
        )
    }
    
    private struct Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
}

extension View {
    func cardify(isFaceUp: Bool, isMatched: Bool, isChosen: Bool) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, isMatched: isMatched, isChosen: isChosen))
    }
}
