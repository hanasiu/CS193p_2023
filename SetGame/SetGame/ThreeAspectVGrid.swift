//import SwiftUI
//
//struct ThreeAspectVGrid<Item: Identifiable, ItemView: View>: View {
//    let items: [[Item]]
//    var aspectRatio: CGFloat = 1
//    let content: (Item) -> ItemView
//    
//    init(_ items: [[Item]], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
//        self.items = items
//        self.aspectRatio = aspectRatio
//        self.content = content
//    }
//    
//    var body: some View {
//        GeometryReader { geometry in
//            let gridItemSize = max(gridItemWidthThatFits(
//                count: items.count,
//                size: geometry.size,
//                atAspectRatio: aspectRatio
//            ), 90)
//            
//                ScrollView {
//                    LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
//                        ForEach(items) { threeItem in
//                            ForEach(threeItem) { eachItem in
//                                content(eachItem)
//                                    .aspectRatio(aspectRatio, contentMode: .fit)
//                            }
//              
//                        }
//                    }
//                }
//  
//        }
//    }
//    
////    ForEach(Array(viewModel.possibleCorrectCards.enumerated()), id: \.offset) { index, threeCards in
////        VStack{
////            ForEach(threeCards) { card in
////                CardView(card) // Ensure this initializer matches your CardView's expectations
////                    .aspectRatio(2/3, contentMode: .fit)
////                    .padding(4)
////        }
////    }
////    
//    private func gridItemWidthThatFits(
//        count: Int,
//        size: CGSize,
//        atAspectRatio aspectRatio: CGFloat
//    ) -> CGFloat {
//        let count = CGFloat(count)
//        var columnCount = 1.0
//        repeat {
//            let width = size.width / columnCount
//            let height = width / aspectRatio
//            
//            let rowCount = (count / columnCount).rounded(.up)
//            if rowCount * height < size.height {
//                return (size.width / columnCount).rounded(.down)
//            }
//            columnCount += 1
//        } while columnCount < count
//        return min(size.width / count, size.height * aspectRatio).rounded(.down)
//    }
//}
//
