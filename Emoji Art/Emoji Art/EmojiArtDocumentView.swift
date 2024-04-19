
import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    @ObservedObject var document: EmojiArtDocument
    
    private let emojis = "👻🍎😃🤪☹️🤯🐶🐭🦁🐵🦆🐝🐢🐄🐖🌲🌴🌵🍄🌞🌎🔥🌈🌧️🌨️☁️⛄️⛳️🚗🚙🚓🚲🛺🏍️🚘✈️🛩️🚀🚁🏰🏠❤️💤⛵️"
    
    private let paletteEmojiSize: CGFloat = 40
    
    @State private var selectedEmojis: Set<Emoji.ID> = []
    
    func toggleEmoji(of emojiId: Emoji.ID) {
        if(isSelected(of: emojiId)) {
            selectedEmojis.remove(emojiId)
        } else {
            selectedEmojis.insert(emojiId)
        }
    }
    
    func isSelected(of emojiId: Emoji.ID) -> Bool {
        return selectedEmojis.contains(emojiId)
    }
    
    func turnOffSelect() {
        selectedEmojis.removeAll()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            PaletteChooser()
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
    }
    
    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                documentContents(in: geometry)
                    .scaleEffect(zoom * gestureZoom)
                    .offset(pan + gesturePan)
            }
            .gesture(panGesture.simultaneously(with: zoomGesture))
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                return drop(sturldatas, at: location, in: geometry)
            }
            .onTapGesture {
                turnOffSelect()
            }
        }
    }
    
    @State private var zoom: CGFloat = 1
    @State private var pan: CGOffset = .zero
    @State private var emojiPan: CGOffset = .zero
    @State private var clickedEmojiId: Int = -1
    
    @GestureState private var gestureZoom: CGFloat = 1
    @GestureState private var emojiGestureZoom: CGFloat = 1
    @GestureState private var gesturePan: CGOffset = .zero
    @GestureState private var emojiGesturePan: CGOffset = .zero
    @GestureState private var unselectedEmojiGesturePan: CGOffset = .zero
    
    @State private var showAlert = false
    @State private var emojiIdToDelete: Int?
    let alertTitle: String = "Delete Emoji"
    
    private var zoomGesture: some Gesture {
        //Since 2023 lecture, some of api have changed.
        //MagnificationGesture - deprecated
        //from MagnificationGesture to MagnifyGesture
        if(selectedEmojis.isEmpty) {
            return MagnifyGesture()
                .updating($gestureZoom) {
                    inMotionPinchScale, gestureZoom, _ in
                    gestureZoom = inMotionPinchScale.magnification
                }
                .onEnded { endingPinchScale in
                    zoom *= endingPinchScale.magnification
                }
        } else {
            return MagnifyGesture()
                .updating($emojiGestureZoom) {
                    inMotionPinchScale, emojiGestureZoom, _ in
                    emojiGestureZoom = inMotionPinchScale.magnification
                }
                .onEnded { endingPinchScale in
                    document.changeEmojiZoom(selectedEmojis: selectedEmojis, magnifiedZoom: endingPinchScale.magnification  * emojiGestureZoom)
                }
        }
        
    }
    
    private var panGesture: some Gesture {
        DragGesture()
            .updating($gesturePan) { value, gesturePan, _ in
                gesturePan = value.translation
            }
            .onEnded { value in
                pan += value.translation
            }
    }
    
    private var emojiPanGesture: some Gesture {
        return DragGesture()
            .updating($emojiGesturePan) { value, gestureEmojiPan, _ in
                gestureEmojiPan = (selectedEmojis.count > 0) ?
                value.translation : gestureEmojiPan
            }
            .onEnded { value in
                document.changeEmojiPosition(selectedEmojis: selectedEmojis, addedDistance: value.translation)
            }
    }

    @ViewBuilder
    private func documentContents(in geometry: GeometryProxy) -> some View {
        AsyncImage(url: document.background)
            .position(Emoji.Position.zero.in(geometry))
        ForEach(document.emojis) { emoji in
            Text(emoji.string)
                .font(.system(size: CGFloat(emoji.size)))
                .scaleEffect(isSelected(of: emoji.id) ? emojiGestureZoom : 1)
                .border(.red, width: isSelected(of: emoji.id) ? 3 : 0)
                .font(emoji.font)
                .position(emoji.position.in(geometry))
                .onTapGesture {
                    toggleEmoji(of: emoji.id)
                }
                .offset(isSelected(of: emoji.id) ? emojiGesturePan : clickedEmojiId == emoji.id ? unselectedEmojiGesturePan : CGOffset(width: 0,height: 0))
                .gesture(isSelected(of: emoji.id) ? emojiPanGesture.simultaneously(with: zoomGesture) : nil)
                .gesture(isSelected(of: emoji.id) ? nil :  DragGesture()
                    .onChanged( { _ in
                        clickedEmojiId = emoji.id
                    })
                        .updating($unselectedEmojiGesturePan) { value, gestureEmojiPan, _ in
                            gestureEmojiPan = value.translation
                        }
                    .onEnded { value in
                        document.changeUnselectedEmojiPosition(emojiId: emoji.id, addedDistance: value.translation)
                    })
                .onLongPressGesture {
                    emojiIdToDelete = emoji.id
                    showAlert = true
                }
                .alert(
                    alertTitle,
                    isPresented: $showAlert
                ) {
                    Button(role: .destructive) {
                        document.deleteEmoji(emoji.id)
                    }
                label: {
                    Text("Delete \(emoji.string)")
                }
                }
        message: {
            Text("Delete \(emoji.string)?")
        }
        }
    }
    
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        for sturldata in sturldatas {
            switch sturldata {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document.addEmoji(
                    emoji,
                    at: emojiPosition(at: location, in: geometry),
                    size:paletteEmojiSize / zoom
                )
                return true
            default:
                break
                
            }
        }
        return false
    }
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(x: Int((location.x - center.x - pan.width) / zoom), y: Int(-(location.y - center.y - pan.height) / zoom))
    }
}



#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
        .environmentObject(PaletteStore(named: "Preview"))
}
