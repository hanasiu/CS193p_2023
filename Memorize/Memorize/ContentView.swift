//
//  ContentView.swift
//  Memorize
//
//  Created by kimyu on 1/6/24.
//

import SwiftUI

struct ContentView: View {
    let emojis: [String] = ["🐳", "🦀", "🐙", "🐠", "🦭", "🦈", "🦐", "🪼", "🐡", "🐟"]
    
    @State var cardCount: Int = 4
    
    var body: some View {
        VStack {
            HStack {
                ForEach(0..<cardCount, id: \.self) { index in
                    CardView(content: emojis[index])
                }
            }
            .foregroundColor(.blue)
            HStack {
                Button("Add Card") {
                    cardCount += 1
                }
                Button("Remove Card") {
                    cardCount -= 1
                }
            }
            .foregroundColor(.orange)
        }
        .foregroundColor(.mint )
        .padding()
        
    }
    
}

struct CardView: View {
    let content: String
    @State var isFaceUp = true
    var body: some View {
            ZStack
          {
              let base =  RoundedRectangle(cornerRadius: 12)
              if isFaceUp {
                    base.fill(.white)
                    base.strokeBorder(lineWidth: 2)
                    Text(content)
                        .font(.largeTitle)
              } else {
                    base
              }
          }
          .onTapGesture {
              isFaceUp.toggle()
          }
        
    }
}

#Preview {
    ContentView()}
