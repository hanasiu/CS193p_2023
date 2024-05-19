import SwiftUI

struct ThemeEditor: View {
    @Binding var theme: Theme
    
    @State var numberOfPairs: Int = 0
    
    init(theme: Binding<Theme>) {
        _theme = theme
        _numberOfPairs = State(initialValue: theme.wrappedValue.numberOfPairs ?? theme.wrappedValue.emojis.count)
    }
    enum Focused {
        case name
        case addEmojis
        case number
    }
    
    @FocusState var focused: Focused?
    
    var body: some View {
        Form {
            NameSection(theme: $theme, focused: _focused)
            EmojiSection(theme: $theme, numberOfPairs: $numberOfPairs, focused: _focused)
        }
        .frame(minWidth: 300, minHeight: 350)
        .onAppear {
            if theme.name.isEmpty {
                focused = .name
            } else {
                focused = .addEmojis
            }
        }
    }
    
    struct NameSection: View {
        @Binding var theme: Theme
        @FocusState var focused: Focused?
        
        private var colorBinding: Binding<Color> {
            Binding<Color>(
                get: { self.theme.rgbaToColor() },
                set: { self.theme.color = $0.toRGBA() }
            )
        }
        
        var body: some View {
            Section(header: Text("Name")) {
                HStack {
                    TextField("Name", text: $theme.name)
                        .focused($focused, equals: .name)
                    ColorPicker("", selection: colorBinding)
                }
            }
        }
    }
    
    struct EmojiSection: View {
        @Binding var theme: Theme
        @Binding var numberOfPairs: Int
        @FocusState var focused: Focused?
        
        private let emojiFont = Font.system(size: 40)
        
        @State private var emojiToAdd: String = ""
        
        @State private var emojisToAdd: [String] = []
        @State var showAlert = false
        
        @State var emojiToDelete: String?
        
        enum alertPicker {
            case delete, belowTwo
        }
        
        @State private var currentAlert: alertPicker?
        
        var body: some View {
            Section(header: HeaderView(title: "Emojis", subtitle: "Tab emoji to delete or re-add")) {
                emojis
                addEmojis
                cardPairsChanger
                removedEmojis
            }
        }
        
        var emojis: some View {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 40))]) {
                ForEach(theme.emojis, id: \.self) { emoji in
                    Text(emoji)
                        .onTapGesture {
                            emojiToDelete = emoji
                            if theme.emojis.count > 2 {
                                currentAlert = .delete
                                showAlert = true
                            } else {
                                currentAlert = .belowTwo
                                showAlert = true
                            }
                        }
                }
            }
            .alert(isPresented: $showAlert) {
                switch currentAlert {
                case .delete:
                    return Alert(
                        title: Text("Delete Emoji"),
                        message: Text("Are you sure you want to delete this emoji?"),
                        primaryButton: .default(Text("Ok")) {
                            if let emoji = emojiToDelete, let index = theme.emojis.firstIndex(of: emoji) {
                                theme.emojis.remove(at: index)
                                if !theme.removedEmojis.contains(where: { $0 == emojiToDelete }) {
                                    theme.removedEmojis.insert(emojiToDelete ?? "", at: 0)
                                }
                            }
                        },
                        secondaryButton: .cancel()
                    )
                case .belowTwo:
                    return Alert(
                        title: Text("Not Allowed Action"),
                        message: Text("Sorry, at least 2 emojis should exist."),
                        primaryButton: .default(Text("Ok")) {
                            focused = .addEmojis
                        },
                        secondaryButton: .cancel()
                    )
                    
                case .none:
                    return Alert(
                        title: Text("error"),
                        message: Text("error"),
                        primaryButton: .default(Text("Ok")) {
                        },
                        secondaryButton: .cancel()
                    )
                }
            }}
        var removedEmojis: some View {
            HStack {
                Text("removed recently : ")
                LazyVGrid(columns : [GridItem(.adaptive(minimum: 40))]) {
                    ForEach(theme.removedEmojis, id: \.self) { emoji in
                        Text(emoji)
                            .onTapGesture {
                                if let index = theme.removedEmojis.firstIndex(of: emoji) {
                                    theme.removedEmojis.remove(at: index)
                                    if !theme.emojis.contains(where: { $0 == emoji }) {
                                        theme.emojis.insert(emoji, at: theme.emojis.count-1)
                                        print("already added")
                                    }
                                }
                            }
                    }
                }
            }
        }
        
        var addEmojis: some View {
            TextField("New Emoji", text: $emojiToAdd)
                .focused($focused, equals: .addEmojis)
                .font(emojiFont)
                .onChange(of: emojiToAdd) {
                    if emojiToAdd.isComposedOnlyOfEmoji {
                        if emojiToAdd.count == 1 {
                            if let index = theme.emojis.firstIndex(where: { $0 == emojiToAdd }) {
                                print("Already Added")
                            } else {
                                theme.emojis.insert(emojiToAdd, at: 0)
                            }
                            emojiToAdd = ""
                        }
                    } else {
                        // Optionally clear `emojiToAdd` or notify the user that the input is not valid
                        emojiToAdd = ""
                        // Display some error message or handle the situation appropriately
                    }
                }
            
        }
        
        var cardPairsChanger: some View {
            Stepper(value: $numberOfPairs,
                    in: 2...theme.emojis.count,
                    step: 1
            ) {
                Text("\(theme.numberOfPairs != nil ? "\(theme.numberOfPairs!)" : "All") From \(theme.emojis.count) pairs of card")
            }.onChange(of: numberOfPairs) {
                theme.numberOfPairs = numberOfPairs
            }
            
        }
    }
    
    struct HeaderView: View {
        var title: String
        var subtitle: String
        
        var body: some View {
            HStack {
                Text(title).bold()
                Spacer()
                Text(subtitle)
                
                    .foregroundColor(.gray)
            }
        }
    }
}
