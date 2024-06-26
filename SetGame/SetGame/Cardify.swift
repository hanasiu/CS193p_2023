import SwiftUI


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
                .strokeBorder(isFaceUp ? isChosen ? isMatched ? .green : .red : .blue : .blue, lineWidth: isFaceUp ? isChosen ? isMatched ?  8 : 6 : 4 : 4)
                .background(base.fill(.white))
                .shadow(color: .red, radius:0.1)
                .overlay(content)
                .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1)
        }
        .rotation3DEffect(
            .degrees(rotation),
            axis: (x: 0.0, y: 1.0, z: 0.0)
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
