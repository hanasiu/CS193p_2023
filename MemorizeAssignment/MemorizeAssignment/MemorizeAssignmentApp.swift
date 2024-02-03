

import SwiftUI

@main
struct MemorizeAssignmentApp: App {

    @StateObject var game = EmojiMemoryGame(themes: themes)
    
    var body: some Scene {
        WindowGroup {
            EmojiMemoryGameView(viewModel: game)
        }
    }
}
