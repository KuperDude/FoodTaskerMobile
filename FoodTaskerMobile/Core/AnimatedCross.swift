//
//  AnimatedCross.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 19.11.2023.
//

import SwiftUI

//struct Cross: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//
//        path.move(to: CGPoint(x: 0, y: 0))
//        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
//
//        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
//        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
//        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
//
//        path.move(to: CGPoint(x: rect.midX, y: rect.midY))
//        path.addLine(to: CGPoint(x: 0, y: 0))
//        return path
//   }
//}



struct AnimatedCrossView: View {
    @Binding var offsetY: CGFloat
    var maxOffsetY: CGFloat
    var height: CGFloat
    var action: ()->Void
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .aspectRatio(1/1, contentMode: .fit)
                    .frame(height: height)
                    .foregroundColor(.theme.background)
                    .shadow(
                        color: Color.theme.accent.opacity(0.15),
                        radius: 5, x: 0, y: 0)
                
                MenuViewStatic(status: .cross)
                    .frame(width: height/2, height: height/2)
                    .rotationEffect(Angle(degrees: 45))
                    .rotationEffect(Angle(degrees: offsetY * 45 / maxOffsetY))
                
            }
        }
        .buttonStyle(NoAnim())
    }
}
