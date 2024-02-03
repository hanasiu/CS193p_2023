
import Foundation
import SwiftUI

class EmojiMemoryGame: ObservableObject {
    static var halloweenEmojis: [String] = ["🦇", "👿", "👹", "👺", "💩", "👻", "💀", "☠️", "👽", "👾", "🤖", "😻"]
    static var seaEmojis: [String] =  ["🐳", "🦀", "🐙", "🐠", "🦭", "🦈", "🦐", "🪼", "🐡", "🐟"]
    static var animalEmojis: [String] = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐯", "🐮", "🐷", "🐵", "🐤", "🐔", "🦄"]
    static var countryEmojis: [String] = ["🇧🇸","🇬🇪","🇲🇰","🇲🇽","🇬🇷","🇨🇦","🇧🇷","🇧🇪","🇽🇰","🇨🇮","🇺🇳","🇵🇫","🇰🇷","🇶🇦"]
    static var ballEmojis: [String] = ["⚽️","🏀","🏈","⚾️","🎾","🏐","🏉","🥏","🎱","🪀","🏓","🏸"]
    static var fruitEmojis: [String] = ["🍏","🍎","🍐","🍋","🍐","🍌","🍉","🍇","🍓","🫐","🍒","🍑","🍍","🥝","🥥","🍅"]
    
    private static let themes: [Theme] = [
        Theme(name: "halloween", emoji: halloweenEmojis, color: "red"),
        Theme(name: "sea", emoji: seaEmojis, numberOfPairs: 6, color: "blue"),
        Theme(name: "animal", emoji: animalEmojis, numberOfPairs: 7, color: "purple"),
        Theme(name: "country", emoji: countryEmojis, numberOfPairs: 8, color: "orange"),
        Theme(name: "ball", emoji: ballEmojis, color: "black"),
        Theme(name: "fruit", emoji: fruitEmojis, numberOfPairs: 10, color: "green"),
    ]
    
    private static func createGameTheme(themes: [Theme]) -> Theme {
        //selectedTheme = themes.randomElement()!
        //        Theme(numberOfThemes: 5) { index in
        //            if themes.indices.contains(index) {
        //                return Theme(
        //                               name: "haha",
        //                               emojis: themes[index],
        //                               numberOfPairs: themes.count,
        //                               color: "blue"
        //                           )
        //            } else {
        //                return Theme(
        //                    name: "Default",
        //                    emojis: ["⁉️"],
        //                    numberOfPairs: 1,
        //                    color: "gray"
        //                )
        //            }
        //        }
        let theme = themes.randomElement()!
        //        theme.emoji = theme.emoji.shuffle
        return theme
    }
    
    @Published private var themeModel = EmojiMemoryGame.createGameTheme(themes: themes)
    
    var theme:  Theme {
        return themeModel
    }
    
    
    //@State var selectedEmoji = ""
    
    //    private static var selectedTheme: Theme = Theme()
    //    private static let themes: [Theme] = [
    //        Theme(name: "test", emoji: halloweenEmojis, numberOfPairs: 5, color: "red"),
    //        Theme(name: "test1", emoji: seaEmojis, numberOfPairs: 7, color: "blue")
    //    ]
    
    private static func createMemoryGame(emoji: [String]) -> MemoryGame<String> {
        // print(emoji.count)
        return MemoryGame(numberOfPairsOfCards: emoji.count) {
            pairIndex in
            if emoji.indices.contains(pairIndex) {
                return emoji[pairIndex]
            } else {
                return "⁉️"
            }
        }
    }
    
    //        GameTheme(name: "haha", emoji: seaEmojis,
    //                  numberOfPairs: 10, color: "red")
    //    }
    
    @Published private var model: MemoryGame<String>! /*EmojiMemoryGame.createMemoryGame(emoji: themeModel.emoji)*/
    
    init(themes: [Theme]) {
        themeModel = EmojiMemoryGame.createGameTheme(themes: themes)
        themeModel.prefix()
        //        themeModel.emoji = themeModel.emoji.prefix(themeModel.numberOfPairs)
        //    print(themeModel.emoji[0])
        model = EmojiMemoryGame.createMemoryGame(emoji: themeModel.emoji)
        model.shuffle()
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
        themeModel = EmojiMemoryGame.createGameTheme(themes: EmojiMemoryGame.themes)
        themeModel.prefix()
        model = EmojiMemoryGame.createMemoryGame(emoji: themeModel.emoji)
        model.shuffle()
    }
    
    func interpretThemeColor() -> Color
    {
        themeModel.interpretThemeColor()
    }
    //    func interpretThemeColor() -> Gradient {
    //        themeModel.interpretThemeGredient()
    //        }
    
    
    
    
    
    //    func randomTheme() -> GameTheme.Theme {
    //        return themeModel.randomGameTheme()
    //    }
    
}

