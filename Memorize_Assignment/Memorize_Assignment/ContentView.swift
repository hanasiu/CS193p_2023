//
//  ContentView.swift
//  Memorize_Assignment
//
//  Created by kimyu on 1/9/24.
//

import SwiftUI

struct ContentView: View {
    @State var emojis: [String] = []
    var halloweenEmojis: [String] = ["🦇", "👿", "👹", "👺", "💩", "👻", "💀", "☠️", "👽", "👾", "🤖", "😻"]
    var seaEmojis: [String] =  ["🐳", "🦀", "🐙", "🐠", "🦭", "🦈", "🦐", "🪼", "🐡", "🐟"]
    var animalEmojis: [String] = ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐯", "🐮", "🐷", "🐵", "🐤", "🐔", "🦄"]
    @State var selectedEmoji = ""
    var body: some View {
        VStack {
            Text("Memorize!").font(.title)
            ScrollView{
                cards
            }
            Spacer()
            emojiSelectorList
        }
        .foregroundColor(.mint)
        .padding()
    }
    
    var cards: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 60))]) {
            ForEach(emojis.indices, id:\.self) { index in
                CardView(content: emojis[index]).aspectRatio(2/3, contentMode: .fit)
            }.font(.system(size: 50))
        }
        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
    }
    
    var emojiSelectorList: some View {
        HStack{
            Spacer()
                selectAnimal
            Spacer()
                selectSea
            Spacer()
                selectHalloween
            Spacer()
        }
        .foregroundColor(.yellow)
        .imageScale(.large)
    }
    
    func emojiSelector(emojiName: String, symbol: String) -> some View {
        VStack {
            Button(action: {
                selectedEmoji = emojiName
                if (selectedEmoji == "Animal") {
                    emojis = (animalEmojis + animalEmojis).shuffled()
                }
                else if (selectedEmoji == "Sea") {
                    emojis = (seaEmojis + seaEmojis).shuffled()
                }
                else if (selectedEmoji == "Halloween") {
                    emojis = (halloweenEmojis
                              + halloweenEmojis).shuffled()
                }
            }, label: {Image(systemName: symbol)})
            .font(.system(size: 30))
            Text(emojiName)
                .frame(
                    alignment: .leadingFirstTextBaseline)
        }
    }
    
    var selectAnimal: some View {
            emojiSelector(emojiName: "Animal", symbol: "teddybear.fill")
    }
    
    var selectSea: some View {
        emojiSelector(emojiName: "Sea", symbol: "fish.fill")
    }
    
    var selectHalloween: some View {
        emojiSelector(emojiName: "Halloween", symbol: "party.popper.fill")
    }

}

struct CardView: View {
    let content: String
    @State var isFaceUp = false
    var body: some View {
        ZStack{
            let base = RoundedRectangle(cornerRadius: 12)
            Group {
                base.fill(.white)
                base.strokeBorder(.blue)
                Text(content)
            }
            .opacity(isFaceUp ? 1 : 0)
            base.fill().opacity(isFaceUp ? 0 : 1 )
        }
        .onTapGesture {
            isFaceUp.toggle()
        }
    }
}


#Preview {
    ContentView()
}
