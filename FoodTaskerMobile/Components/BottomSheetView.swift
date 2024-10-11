//
//  BottomSheetView.swift
//  FoodTaskerMobile
//
//  Created by MyBook on 21.05.2023.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @Binding var isOpen: Bool

    let maxHeight: CGFloat
    let minHeight: CGFloat
    let offsetY: CGFloat
    let content: Content
    let isAllowPresent: Bool

    init(isOpen: Binding<Bool>, maxHeight: CGFloat, minHeight: CGFloat?, offsetY: CGFloat, isAllowPresent: Bool, @ViewBuilder content: () -> Content) {
        self.maxHeight = maxHeight
        if let minHeight = minHeight {
            self.minHeight = minHeight
        } else {
            self.minHeight = 0
        }
        self.content = content()
        self._isOpen = isOpen
        self.offsetY = offsetY
        self.isAllowPresent = isAllowPresent
    }
    
    private var offset: CGFloat {
        return isOpen ? minHeight : maxHeight
    }

    private var indicator: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.secondary)
            .frame(
                width: 30,
                height: 5
        )
    }
    
    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                self.indicator.padding()
                self.content
            }
            .frame(width: geometry.size.width, height: self.maxHeight, alignment: .top)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(self.offset + self.translation, isOpen ? 0 : offsetY))
            .animation(.interactiveSpring(), value: isOpen)
            .animation(.interactiveSpring(), value: translation)
            .gesture(
                DragGesture().updating(self.$translation) { value, state, _ in
                    if isAllowPresent {
                        state = value.translation.height
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OffsetYChange"), object:
                            CGFloat(isOpen ?
                                min(2*(maxHeight - offsetY), max(self.translation + maxHeight - offsetY, maxHeight - offsetY)) :
                                min(0, max(offsetY - maxHeight, self.translation))
                            )
                        )
                    }
                }.onEnded { value in
                    if isAllowPresent {
                        let snapDistance = self.maxHeight * 0.3
                        guard abs(value.translation.height) > snapDistance else {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OffsetYChange"), object: CGFloat(isOpen ? maxHeight - offsetY : minHeight))
                            return
                        }
                        self.isOpen = value.translation.height < 0
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OffsetYChange"), object: CGFloat(isOpen ? maxHeight - offsetY : minHeight))
                    }
                }
            )
        }
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(isOpen: .constant(true), maxHeight: 200, minHeight: 0, offsetY: .zero, isAllowPresent: true, content: {
            Text("hi hi hi")
        })
    }
}
