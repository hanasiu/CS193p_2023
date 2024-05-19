//
//import SwiftUI
//
//struct ThemeChooser: View {
//    //@EnvironmentObject var game: EmojiMemoryGame
//
//    @State private var showThemeEditor = false
//    @State private var showThemeList = true
//    
//    var body: some View {
//        HStack {
//            chooser
//        }
//    }
//    
//    var chooser: some View {
//        Button("Themes", systemImage: "chevron.backward") {
//            showThemeList = true
//        }
//        .sheet(isPresented: $showThemeList) {
//            // Placeholder for your theme list view
//        //    ThemeList(isPresented: $showThemeList)
//        }
//    }
//}
//        .contextMenu(ContextMenu(menuItems: {
//            gotoMenu
////            AnimatedActionButton("New", systemImage: "plus") {
////                store.insert(name: "", emojis: "")
////                showPaletteEditor = true
////            }
////            AnimatedActionButton("Delete", systemImage: "minus.circle", role: .destructive) {
////                store.palettes.remove(at: store.cursorIndex)
////            }
////            AnimatedActionButton("Edit", systemImage: "pencil") {
////                showPaletteEditor = true
////            }
//            AnimatedActionButton("List", systemImage: "list.bullet.rectangle.portrait") {
//                showThemeList = true
//            }
//        }))
//    }
//    
//
//    private var gotoMenu: some View {
//        Menu {
//            ForEach(store.themes) { theme in
//                AnimatedActionButton(theme.name) {
//                    
//                }
//            }
//        } label: {
//            Label("Go To", systemImage: "text.insert")
//        }
//    }
    


//#Preview {
//    ThemeChooser().environmentObject(ThemeStore(named: "Preview"))
//}
