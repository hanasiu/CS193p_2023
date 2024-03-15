//
//import SwiftUI
//
//struct CardPick: Shape {
//    func path(in rect: CGRect) -> Path {
//        <#code#>
//    }
//    
//    let squiggle = Squiggle()
//        .fill(getColor())
//        .overlay(
//            Squiggle()
//                .stroke(getBorderColor(), lineWidth: card.shading == "open" || card.shading == "striped" ? 3.0 : 0.0)
//        )
//        .overlay(Stripe()
//            .stroke(getBorderColor(), lineWidth: card.shading == "striped" ? 3.0 : 0.0))
//        .clipShape(Squiggle())
//        .aspectRatio(1/2, contentMode: .fit)
//    
//    let oval =  Ellipse()
//        .foregroundColor(getColor())
//        .overlay(
//            Ellipse()
//                .strokeBorder(getBorderColor(), lineWidth: card.shading == "open" || card.shading ==
//                              "striped" ? 3.0 : 0.0)
//        )
//        .overlay(Stripe()
//            .stroke(getBorderColor(), lineWidth: card.shading == "striped" ? 3.0 : 0.0))
//        .clipShape(Ellipse())
//        .aspectRatio(1/2, contentMode: .fit)
//    
//    let diamond = Diamond()
//        .foregroundColor(getColor())
//        .overlay(
//            Diamond()
//                .stroke(getBorderColor(), lineWidth: card.shading == "open" || card.shading == "striped" ? 3.0 : 0.0)
//        )
//        .overlay(Stripe()
//            .stroke(getBorderColor(), lineWidth: card.shading == "striped" ? 3.0 : 0.0))
//        .clipShape(Diamond())
//        .aspectRatio(1/2, contentMode: .fit)
//    
//    
//    switch card.number {
//    case 1:
//        switch card.shape {
//        case "oval":
//            oval
//        case "rectangle":
//            squiggle
//        case "diamond":
//            diamond
//        default:
//            EmptyView()
//        }
//    case 2:
//        switch card.shape {
//        case "oval":
//            oval
//            oval
//        case "rectangle":
//            squiggle
//            squiggle
//        case "diamond":
//            diamond
//            diamond
//        default:
//            EmptyView()
//        }
//    case 3:
//        switch card.shape {
//        case "oval":
//            oval
//            oval
//            oval
//        case "rectangle":
//            squiggle
//            squiggle
//            squiggle
//        case "diamond":
//            diamond
//            diamond
//            diamond
//        default:
//            EmptyView()
//        }
//    default:
//        EmptyView()
//    }
//}
//
//func getColor() -> Color {
//    switch card.shading {
//    case "solid":
//        break;
//    case "striped":
//        return .white
//    case "open":
//        return .white
//    default:
//        return .white
//    }
//    switch card.color {
//    case "yellow":
//        return .yellow
//    case "green":
//        return .green
//    case "purple":
//        return .purple
//    default:
//        return .yellow
//    }
//}
//
//func getBorderColor() -> Color {
//    switch card.color {
//    case "yellow":
//        return .yellow
//    case "green":
//        return .green
//    case "purple":
//        return .purple
//    default: return .yellow
//    }
//}
//}
