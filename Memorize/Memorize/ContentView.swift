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
            CardView(isFaceUp: true)
            CardView()
        }
        .foregroundColor(.mint )
        .padding()
        
    }
    
}

struct CardView: View {
    var isFaceUp: Bool = false
    var body: some View {
        if isFaceUp {
            ZStack(
                content: {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.white)
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(lineWidth: 2)
                    
                    Text("🐳")
                        .font(.largeTitle)
                })
        } else {
            ZStack(
                content: {
                    RoundedRectangle(cornerRadius: 12)
                })
        }
        
    }
}

#Preview {
    ContentView()}
