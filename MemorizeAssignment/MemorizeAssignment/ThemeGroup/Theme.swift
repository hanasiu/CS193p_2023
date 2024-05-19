
import Foundation
import SwiftUI


struct Theme: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var name = ""
    var emojis: [String] = []
    var removedEmojis: [String] = []
    var numberOfPairs: Int?
    var color = RGBA(red: 0, green: 0, blue: 0, alpha: 0)
    
    init(name: String, emojis: [String], numberOfPairs: Int, color: RGBA) {
        self.name = name
        self.emojis = emojis.uniqued
        self.removedEmojis = removedEmojis.uniqued
        self.numberOfPairs = numberOfPairs
        self.color = color
    }
    
    init(name: String, emojis: [String], color: RGBA) {
        self.name = name
        self.emojis = emojis.uniqued
        self.color = color
    }
    
    init() {
        self.name = "default"
        self.emojis = []
        self.removedEmojis = []
        self.numberOfPairs = 5
        self.color = RGBA(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    mutating func prefix() {
        emojis.shuffle()
        //if emoji.count < numberOfPairs -> all emojis appear
        //if numberOfPairs is nil, prefix -> random number
        emojis = emojis.prefix(numberOfPairs ?? Int.random(in: 2..<emojis.count)).map{String($0)}
    }
    
    func GameTheme() -> Theme {
        return self
    }
    
    static var builtins: [Theme] = [
        Theme(name: "halloween", emojis: halloweenEmojis, color: RGBA(red:255/255, green: 0, blue: 0, alpha: 1.0)),
        Theme(name: "sea", emojis: seaEmojis, numberOfPairs: 6, color: RGBA(red:0, green: 0, blue: 255/255, alpha: 1.0)),
        Theme(name: "animal", emojis: animalEmojis, numberOfPairs: 7, color: RGBA(red:0, green: 255/255, blue: 0, alpha: 1.0)),
        Theme(name: "country", emojis: countryEmojis, numberOfPairs: 8, color: RGBA(red:255/255, green: 255/255, blue: 0, alpha: 1.0)),
        Theme(name: "ball", emojis: ballEmojis, color: RGBA(red:255/255, green: 0, blue: 0, alpha: 1.0)),
        Theme(name: "fruit", emojis: fruitEmojis, numberOfPairs: 10, color: RGBA(red:255/255, green: 0, blue: 255/255, alpha: 1.0))
    ]
}



