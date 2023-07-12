//
//  View.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 30.12.2022.
//

import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct BottomSheet: ViewModifier {
    
    @Binding var bottomSheetShown: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            Color.black
                .opacity(bottomSheetShown ? 0.5 : 0)
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                BottomSheetView(
                    isOpen: self.$bottomSheetShown,
                    maxHeight: geometry.size.height * 0.8
                ) {
                    content
                }
            }.edgesIgnoringSafeArea(.all)
        }
    }
}

extension View {
    func presentAsBottomSheet(_ present: Binding<Bool>) -> some View {
        modifier(BottomSheet(bottomSheetShown: present))
    }
}

//struct Badge: ViewModifier {
//    var count: Int
//    func body(content: Content) -> some View {
//        content
//            .overlay(alignment: .bottomTrailing) {
//                GeometryReader { geometry in
//                    ZStack {
//                        Circle()
//                            .fill(Color.theme.red)
//                        
//                        Text("\(count)")
//                            .foregroundColor(.theme.accent)
//                    }
//                    .frame(width: min(geometry.size.width, geometry.size.height) / 3, height: min(geometry.size.width, geometry.size.height) / 3, alignment: .bottomTrailing)
//                }
//            }
//    }
//}
//
//extension View {
//    func badge(count: Int) -> some View {
//        modifier(Badge(count: count))
//    }
//}
