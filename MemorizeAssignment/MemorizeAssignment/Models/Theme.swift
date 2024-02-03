
import Foundation
import SwiftUI



struct Theme {
    
    var name = ""
    var emoji: [String] = []
    var numberOfPairs: Int?
    var color: String
    
    init(name: String, emoji: [String], numberOfPairs: Int, color: String) {
        self.name = name
        self.emoji = emoji
        self.numberOfPairs = numberOfPairs
        self.color = color
    }
    
    init(name: String, emoji: [String], color: String) {
        self.name = name
        self.emoji = emoji
        self.color = color
    }
    
    init() {
        self.name = "default"
        self.emoji = []
        self.numberOfPairs = 5
        self.color = "blue"
    }
    
    mutating func prefix() {
        emoji.shuffle()
        //if emoji.count < numberOfPairs -> all emojis appear
        //if numberOfPairs is nil, prefix -> random number
        emoji = emoji.prefix(numberOfPairs ?? Int.random(in: 2..<emoji.count)).map{String($0)}
    }
    
    func GameTheme() -> Theme {
        return self
    }
    func interpretThemeColor() -> Color {
        switch(color) {
        case "red": return .red
        case "blue": return .blue
        case "green": return .green
        case "black": return .black
        case "purple": return .purple
        case "orange": return .orange
            //color not matched -> default color
        default:
            return .blue
        }
    }
}



