import SwiftUI

var halloweenEmojis: [String] = ["🦇", "👿", "👹", "👺", "💩", "👻", "💀", "☠️", "👽", "👾", "🤖", "😻"]
var seaEmojis: [String] =  ["🐳", "🦀", "🐙", "🐠", "🦭", "🦈", "🦐", "🪼", "🐡", "🐟"]
var animalEmojis: [String] = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐯", "🐮", "🐷", "🐵", "🐤", "🐔", "🦄"]
var countryEmojis: [String] = ["🇧🇸","🇬🇪","🇲🇰","🇲🇽","🇬🇷","🇨🇦","🇧🇷","🇧🇪","🇽🇰","🇨🇮","🇺🇳","🇵🇫","🇰🇷","🇶🇦"]
var ballEmojis: [String] = ["⚽️","🏀","🏈","⚾️","🎾","🏐","🏉","🥏","🎱","🪀","🏓","🏸"]
var fruitEmojis: [String] = ["🍏","🍎","🍐","🍋","🍐","🍌","🍉","🍇","🍓","🫐","🍒","🍑","🍍","🥝","🥥","🍅"]

let themes: [Theme] = [
    Theme(name: "halloween", emojis: halloweenEmojis, color: RGBA(red:255/255, green: 0, blue: 0, alpha: 1.0)),
    Theme(name: "sea", emojis: seaEmojis, numberOfPairs: 6, color: RGBA(red:0, green: 0, blue: 255/255, alpha: 1.0)),
    Theme(name: "animal", emojis: animalEmojis, numberOfPairs: 7, color: RGBA(red:0, green: 255/255, blue: 0, alpha: 1.0)),
    Theme(name: "country", emojis: countryEmojis, numberOfPairs: 8, color: RGBA(red:255/255, green: 255/255, blue: 0, alpha: 1.0)),
    Theme(name: "ball", emojis: ballEmojis, color: RGBA(red:255/255, green: 0, blue: 0, alpha: 1.0)),
    Theme(name: "fruit", emojis: fruitEmojis, numberOfPairs: 10, color: RGBA(red:255/255, green: 0, blue: 255/255, alpha: 1.0))
]

