//
//  EmojiArtDocument.swift
//  Emoji Art
//
//  Created by hanasiu on 3/29/24.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    @Published private var emojiArt = EmojiArt()
    
    init() {
        emojiArt.addEmoji("👩‍🦰", at: .init(x: -200, y:-150), size: 200)
        emojiArt.addEmoji("🐼", at: .init(x: 250, y: 100), size: 80)
    }
    
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    var background: URL? {
        emojiArt.background
    }
    
    // MARK: - Intent(s)
    
    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }
    
   func addEmoji(_ emoji: String, at position: Emoji.Position, size: CGFloat) {
       emojiArt.addEmoji(emoji, at: position, size: size)
    }
    
    func changeEmojiPosition(selectedEmojis: Set<Emoji.ID>, addedDistance: CGOffset) {
        emojiArt.changeEmojiPosition(selectedEmojis: selectedEmojis, addedDistance: addedDistance)
    }
    
    func changeUnselectedEmojiPosition(emojiId: Emoji.ID, addedDistance: CGOffset) {
        emojiArt.changeUnselectedEmojiPosition(emojiId: emojiId, addedDistance: addedDistance)
    }
    
    
    func changeEmojiZoom(selectedEmojis: Set<Emoji.ID>, magnifiedZoom: CGFloat) {
        emojiArt.changeEmojiZoom(selectedEmojis: selectedEmojis, magnifiedZoom: magnifiedZoom)
    }
    
    func deleteEmoji(_ emojiId: Int) {
        emojiArt.deleteEmoji(emojiId)
    }
}


extension EmojiArt.Emoji {
    var font: Font {
        Font.system(size: CGFloat(size))
    }
}

extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        let center = geometry.frame(in: .local).center
        return CGPoint(x: center.x + CGFloat(x), y: center.y - CGFloat(y))
    }
}
