//
//  Emoji_ArtApp.swift
//  Emoji Art
//
//  Created by hanasiu on 3/29/24.
//

import SwiftUI

@main
struct Emoji_ArtApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    @StateObject var paletteStore = PaletteStore(named: "Main")
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: defaultDocument)
                .environmentObject(paletteStore)
        }
    }
}
