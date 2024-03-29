
import SwiftUI

@main
struct SetGameApp: App {
    @StateObject var game = CardSetGame()
    var body: some Scene {
        WindowGroup {
            SetGameView(setGameViewer: game)
        }
    }
}
