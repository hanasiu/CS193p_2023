import SwiftUI

struct Stripe: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        //        for y in stride(from: 0, through: height, by: height / Constants.interval) {
        //                path.move(to: CGPoint(x: 0, y: y))
        //                path.addLine(to: CGPoint(x: width, y: y))
        //            }
        
        // Ensure the stride value is sensible, not less than 1
        let strideValue = max(height / Constants.interval, 1)
        
        for y in stride(from: 0, through: height, by: strideValue) {
            path.move(to: CGPoint(x: 0, y: y))
            path.addLine(to: CGPoint(x: width, y: y))
        }
        return path
    }
    
    
    private struct Constants {
        static let interval: CGFloat = 9
    }
}
