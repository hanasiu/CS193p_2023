
import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    var theme: Theme
    
    private static func createMemoryGame(emojis: [String], numberOfPairs: Int) -> MemoryGame<String> {
        return MemoryGame(numberOfPairsOfCards: numberOfPairs) {
            pairIndex in
            if emojis.indices.contains(pairIndex) {
                return emojis[pairIndex]
            } else {
                return "⁉️"
            }
        }
    }
    
    @Published private var model: MemoryGame<String>!
    
    init(theme: Theme) {
        self.theme = theme
        if (model == nil) {
            model = EmojiMemoryGame.createMemoryGame(emojis: theme.emojis, numberOfPairs: theme.numberOfPairs ?? theme.emojis.count)
            model.shuffle()
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        return model.cards
    }
    
    
    // Mark - Intents
    
    func shuffle() {
        model.shuffle()
    }
    
    func chose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func getScore() -> Int {
        return model.getScore()
    }
    
    func newGame() {
        model = EmojiMemoryGame.createMemoryGame(emojis: theme.emojis, numberOfPairs: theme.numberOfPairs ?? theme.emojis.count)
        model.shuffle()
    }
}

