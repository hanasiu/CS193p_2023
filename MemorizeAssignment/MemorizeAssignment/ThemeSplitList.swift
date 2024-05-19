import SwiftUI

struct ThemeSplitList: View {
    @EnvironmentObject var themeStore: ThemeStore
    @State var selectedThemeId: Theme.ID?
    @State var themeToGame: [Theme.ID: EmojiMemoryGame]
    @State private var columnVisibility =
    NavigationSplitViewVisibility.all
    @State private var showThemeEditor = false
    @State private var showCursorView = false
    @State private var selectedIndex: Int?
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            List(selection: $selectedThemeId) {
                ForEach(themeStore.themes) {
                    theme    in
                    navigationNode(theme: theme)
                        .tag(theme)
                        .swipeActions(edge: .leading) {
                            Button {
                                if let index = themeStore.themes.firstIndex(where: { $0.id == theme.id }) {
                                    themeStore.cursorIndex = index
                                    showThemeEditor = true
                                }
                            } label: {
                                Label("Edit", systemImage: "pencil")
                            }
                        }
                }
                .onDelete { indexSet in
                    withAnimation {
                        themeStore.themes.remove(atOffsets: indexSet)
                    }
                }
                .onMove { indexSet, newOffSet in
                    themeStore.themes.move(fromOffsets: indexSet, toOffset: newOffSet)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        themeStore.cursorIndex = themeStore.insert(Theme(name:"", emojis:["😄","👍"], color:
                                                                            RGBA(red:0, green: 0, blue: 0, alpha: 1.0)), at: 0)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    detail: {
        if selectedThemeId != nil && !showThemeEditor, let index = themeStore.themes.firstIndex(where: { $0.id == selectedThemeId }), let selectedTheme = themeStore.themes.first(where: {$0.id == selectedThemeId})  {
            EmojiMemoryGameView(memoryGame: themeToGame[selectedTheme.id] ?? EmojiMemoryGame(theme: themeStore.themes[index]))
                .onAppear {
                    themeStore.cursorIndex = index
                    if themeToGame[selectedTheme.id] == nil {
                        themeToGame[selectedTheme.id] = EmojiMemoryGame(theme: themeStore.themes[index])
                    }
                }
        } else {
            Text("Select a theme")
        }
    }
    .onAppear() {
        columnVisibility = .all
    }
    .sheet(isPresented: $showThemeEditor) {
        ThemeEditor(theme: $themeStore.themes[themeStore.cursorIndex])
            .font(nil)
            .onChange(of: themeStore.themes) {
                themeToGame[themeStore.themes[themeStore.cursorIndex].id] = EmojiMemoryGame(theme: themeStore.themes[themeStore.cursorIndex])
            }
    }
    }
    
    private func toggleColumnVisibility() {
        columnVisibility = (columnVisibility == .all) ? .detailOnly : .all
    }
}




