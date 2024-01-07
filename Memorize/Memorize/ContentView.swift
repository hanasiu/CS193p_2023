//
//  ContentView.swift
//  Memorize
//
//  Created by kimyu on 1/6/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            CardView(isFaceUp: true)
            CardView()
            CardView(isFaceUp: false)
        }
        .foregroundColor(.mint )
        .padding()
        
    }
    
}

struct CardView: View {
    @State var isFaceUp = true
    var body: some View {
            ZStack
          {
              let base =  RoundedRectangle(cornerRadius: 12)
              if isFaceUp {
                    base.fill(.white)
                    base.strokeBorder(lineWidth: 2)
                    Text("🐳")
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
