import SwiftUI


protocol IsMatchedAndChosen {
    var isMatched: Bool { get }
    var isChosen: Bool { get }
}

struct AspectVGrid<Item: Identifiable & IsMatchedAndChosen, ItemView: View>: View {
    let items: [Item]
    var aspectRatio: CGFloat = 1
    let content: (Item) -> ItemView
    
    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
     
            GeometryReader { geometry in
                let gridItemSize = max(gridItemWidthThatFits(
                    //for three cards chosen
                    count: items.filter { (!$0.isMatched && !$0.isChosen) || $0.isChosen }.count,
                    size: geometry.size,
                    atAspectRatio: aspectRatio
                ), 90)
                ScrollView {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                        ForEach(items) { item in
                            content(item)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                }.animation(.spring, value: gridItemSize)
            }
        }

    
    private func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
