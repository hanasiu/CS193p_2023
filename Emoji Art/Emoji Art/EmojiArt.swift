
import Foundation

struct EmojiArt {
    var background: URL?
    private(set) var emojis = [Emoji]()
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: CGFloat) {
        uniqueEmojiId += 1
        emojis.append(Emoji(
            string: emoji, position: position,
            size: size,
            id: uniqueEmojiId
        ))
    }
    
    mutating func deleteEmoji(_ emojiId: Int) {
        if let index = emojis.firstIndex(where: { $0.id == emojiId }) {
            emojis.remove(at: index)
        }
    }
    
    mutating func changeEmojiPosition(selectedEmojis: Set<Emoji.ID>, addedDistance: CGOffset) {
        for index in emojis.indices {
            if selectedEmojis.contains(emojis[index].id) {
                emojis[index].position.x += Int(addedDistance.width)
                emojis[index].position.y -= Int(addedDistance.height)
            }
        }
    }
    
    mutating func changeUnselectedEmojiPosition(emojiId: Emoji.ID, addedDistance: CGOffset) {
        if let index = emojis.firstIndex(where: { $0.id == emojiId }) {
                emojis[index].position.x += Int(addedDistance.width)
                emojis[index].position.y -= Int(addedDistance.height)
        }
    }

    
    mutating func changeEmojiZoom(selectedEmojis: Set<Emoji.ID>, magnifiedZoom: CGFloat) {
        for index in emojis.indices {
            if selectedEmojis.contains(emojis[index].id) {
                emojis[index].size *= magnifiedZoom
            }
        }
    }
    
    struct Emoji: Identifiable {
        let string: String
        var position: Position
        var size: CGFloat
        
        var id: Int
        
        struct Position {
            var x: Int
            var y: Int
            
            static let zero = Self(x:0, y:0)
        }
    }
}
