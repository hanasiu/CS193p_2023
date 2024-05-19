import SwiftUI

@main
struct MemorizeAssignmentApp: App {
    @StateObject var themeStore = ThemeStore(named: "Main")
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var memoryGame: EmojiMemoryGame {
        EmojiMemoryGame(theme: themeStore.themes[themeStore.cursorIndex])
    }
    
    var themeToGame: [Theme.ID: EmojiMemoryGame] = [:]
    
    var body: some Scene {
        WindowGroup {
            if UIDevice.current.localizedModel == "iPhone" {
                ThemeList(themeToGame: themeToGame)
                    .environmentObject(themeStore)
            } else if UIDevice.current.localizedModel == "iPad" {
                ThemeSplitList(themeToGame: themeToGame)
                    .environmentObject(themeStore)
            }
        }
    }
}
