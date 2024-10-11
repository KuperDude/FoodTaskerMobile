//
//  View.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 30.12.2022.
//

import SwiftUI

struct BottomSheet: ViewModifier {
    
    @Binding var bottomSheetShown: Bool
    
    let maxHeight: CGFloat?
    let minHeight: CGFloat?
    let offsetY: CGFloat
    let isAllowPresent: Bool
    
    func body(content: Content) -> some View {
        ZStack {
            Color.black
                .opacity(bottomSheetShown ? 0.5 : 0)
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                BottomSheetView(
                    isOpen: self.$bottomSheetShown,
                    maxHeight: maxHeight == nil ? geometry.size.height * 0.8 : maxHeight!,
                    minHeight: minHeight,
                    offsetY: offsetY,
                    isAllowPresent: isAllowPresent
                ) {
                    content
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

extension View {
    func presentAsBottomSheet(_ present: Binding<Bool>, maxHeight: CGFloat? = nil, minHeight: CGFloat? = nil, offsetY: CGFloat = .zero, isAllowPresent: Bool = true) -> some View {
        modifier(BottomSheet(bottomSheetShown: present, maxHeight: maxHeight, minHeight: minHeight, offsetY: offsetY, isAllowPresent: isAllowPresent))
    }
}

struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct FramePreferenceKey: PreferenceKey {
    static var defaultValue: CGRect = .zero

    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}
