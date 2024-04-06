import Foundation

func generateAllCards() -> [CardExample] {
    var cards:[CardExample] = []
            struct i:CardProtocol {
                var number: Int
    
                var shape: String
    
                var shading: String
    
                var color: String
    
    
            }
            for number in CardNumber.allCases {
                for shape in CardShape.allCases {
                    for shading in CardShading.allCases {
                        for color in CardColor.allCases {
                            let card = CardExample(number: number.rawValue,
                                                   shape: shape.rawValue,
                                                   shading: shading.rawValue,
                                                   color: color.rawValue)
                            cards.append(card)
                        }
                    }
                }
            }
            return cards
}


var cardInfos: [CardExample] = generateAllCards()



