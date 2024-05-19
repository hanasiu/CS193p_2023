import SwiftUI


struct ThemeList: View {
    @EnvironmentObject var themeStore: ThemeStore
    
    @State var themeToGame: [Theme.ID: EmojiMemoryGame]
    
    @State private var showThemeEditor = false
    @State private var showCursorView = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(themeStore.themes) {
                    theme in
                    NavigationLink(value: theme.id) {
                        navigationNode(theme: theme)
                    }
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
            .navigationTitle("themes")
            .sheet(isPresented: $showThemeEditor) {
                ThemeEditor(theme: $themeStore.themes[themeStore.cursorIndex])
                    .font(nil)
                    .onChange(of: themeStore.themes) {
                        themeToGame[themeStore.themes[themeStore.cursorIndex].id] = EmojiMemoryGame(theme: themeStore.themes[themeStore.cursorIndex])
                    }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        themeStore.cursorIndex = themeStore.insert(Theme(name:"", emojis:["😄","👍"], color:
                                                                            RGBA(red:0, green: 0, blue: 0, alpha: 1.0)), at: 0)
                        showCursorView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationDestination(for: Theme.ID.self) { themeId in
                if let index = themeStore.themes.firstIndex(where: { $0.id == themeId }) {
                    EmojiMemoryGameView(memoryGame: themeToGame[themeId] ?? EmojiMemoryGame(theme: themeStore.themes[themeStore.cursorIndex]))
                        .onAppear {
                            themeStore.cursorIndex = index
                            if themeToGame[themeId] == nil {
                                themeToGame[themeId] = EmojiMemoryGame(theme: themeStore.themes[themeStore.cursorIndex])
                            }
                        }
                }
            }
            .navigationDestination(isPresented: $showCursorView) {
                EmojiMemoryGameView(memoryGame: themeToGame[themeStore.themes[themeStore.cursorIndex].id] ?? EmojiMemoryGame(theme: themeStore.themes[themeStore.cursorIndex]))
            }
        }
    }
}

func navigationNode(theme: Theme) -> some View {
    return VStack(alignment: .leading) {
        Text(theme.name)
            .foregroundStyle(theme.rgbaToColor())
            .font(.title)
        HStack {
            (theme.numberOfPairs != nil) ?  Text("\(theme.numberOfPairs ?? 0) pairs from") : Text("All of")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(theme.emojis, id: \.self) { emoji in
                        Text(emoji)
                    }
                }
            }
            .disabled(true)
        }
    }
}

struct ThemeView: View {
    let theme: Theme
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.emojis.uniqued.map { String($0) }, id: \.self) { emoji in
                    NavigationLink(value: emoji) {
                        Text(emoji)
                    }
                }
            }
            .navigationDestination(for: String.self) { emoji in
                Text(emoji).font(.system(size: 300))
            }
            Spacer()
        }
        .padding()
        .font(.largeTitle)
        .navigationTitle(theme.name)
    }
}
