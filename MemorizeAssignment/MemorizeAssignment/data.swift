import SwiftUI


var halloweenEmojis: [String] = ["🦇", "👿", "👹", "👺", "💩", "👻", "💀", "☠️", "👽", "👾", "🤖", "😻"]
var seaEmojis: [String] =  ["🐳", "🦀", "🐙", "🐠", "🦭", "🦈", "🦐", "🪼", "🐡", "🐟"]
var animalEmojis: [String] = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐯", "🐮", "🐷", "🐵", "🐤", "🐔", "🦄"]
var countryEmojis: [String] = ["🇧🇸","🇬🇪","🇲🇰","🇲🇽","🇬🇷","🇨🇦","🇧🇷","🇧🇪","🇽🇰","🇨🇮","🇺🇳","🇵🇫","🇰🇷","🇶🇦"]
var ballEmojis: [String] = ["⚽️","🏀","🏈","⚾️","🎾","🏐","🏉","🥏","🎱","🪀","🏓","🏸"]
var fruitEmojis: [String] = ["🍏","🍎","🍐","🍋","🍐","🍌","🍉","🍇","🍓","🫐","🍒","🍑","🍍","🥝","🥥","🍅"]


let themes: [Theme] = [
Theme(name: "halloween", emoji: halloweenEmojis, color: "red"),
Theme(name: "sea", emoji: seaEmojis, numberOfPairs: 6, color: "blue"),
Theme(name: "animal", emoji: animalEmojis, numberOfPairs: 7, color: "purple"),
Theme(name: "country", emoji: countryEmojis, numberOfPairs: 8, color: "orange"),
Theme(name: "ball", emoji: ballEmojis, color: "black"),
Theme(name: "fruit", emoji: fruitEmojis, numberOfPairs: 10, color: "green"),
]

